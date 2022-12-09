extends Chara
const Utils = globalData.infoDs["g_aDotaProcess"]
const Buffs = globalData.infoDs["g_BuffList"]
#覆盖的初始化
func _info():
	pass
#继承的初始化，技能描述在这里写，保留之前的技能描述
func _extInit():
	._extInit()#保留继承的处理
	chaName = "炼金术士 - 3级"
	attCoe.atkRan = 1
	attCoe.maxHp = 5
	attCoe.atk = 5
	attCoe.mgiAtk = 2
	attCoe.def = 4
	attCoe.mgiDef = 4
	lv = 3
	evos = ["ym_1"] #可以升级到的生物id
	atkEff = "atk_dao"
	addCdSkill("sxpw",6)
	addSkillTxt("[color=#FF0000][b]力量[/b]：这个单位攻击造成基于自身最大生命值的物理伤害\n")
	addSkillTxt("贪魔的贪婪：场上敌方单位死亡时额外获得3经验和3金币")
	addSkillTxt("酸性喷雾：每6秒向区域喷洒高压喷雾，造成100%攻击力的物理伤害并削弱60护甲，持续3秒")
	addSkillTxt("不稳定化合物：战斗开始时，花费最多5秒时间炼制一瓶不稳定化合物，扔向威胁最大的敌方单位。被化合物击中的目标及其周围的单位受到基于炼制时间的魔法伤害和眩晕，如果生命值低于70%，那么化合物会被提前扔出去")
	addSkillTxt("化学狂暴：投掷不稳定化合物后，会喝下给自己精心调配的药剂，获得8层急速\n")
	addSkillTxt("[color=#00FF00]化合物炼制指南：\n化合物基础威力：200魔法伤害和2秒眩晕\n每多炼制一秒，化合物的伤害就会提升200，晕眩时间延长1秒\n[color=#FF0000]尽情破坏吧！\n")
	addSkillTxt("由于电脑玩家智商不足无法调配药物，我们准备了化合物原浆供它投掷：\n电脑玩家的化合物不需要调配时间即可扔出，造成400魔法伤害和持续2秒的晕眩效果")

var InfoLabel
var DrugPreTime = 0
var DrugStarted = false


#进入战斗初始化，事件连接在这里初始化
func _connect():
	._connect() #保留继承的处理

func _onBattleStart():
	addBuff(Buffs.Buff_Talnet.new(Buffs.POWER))
	if team == 1:
		masCha.aiOn = false
		if InfoLabel != null:
			InfoLabel.text = "正在调制药物，剩余5秒"
			InfoLabel.visible = true
		else:
			InfoLabel = Utils.UI_CreateLayerText("正在调制药物，剩余5秒", position + Vector2(275,100))
		DrugStarted = true
		DrugPreTime = 0
	else:
		DrugThrow()

func _upS():
	if DrugStarted == true && DrugPreTime < 5 && att.hp > att.maxHp*0.7:
		InfoLabel.text = "正在调制药物，剩余{s}秒".format({"s":(5 - DrugPreTime - 1)})
		DrugPreTime += 1
	if DrugStarted == true && DrugPreTime >= 5:
		print("最大")
		InfoLabel.visible = false
		DrugStarted = false
		DrugThrow()
	if DrugStarted == true && DrugPreTime < 5 && att.hp <= att.maxHp*0.7:
		InfoLabel.visible = false
		DrugStarted = false
		DrugThrow()


func _onCharaDel(cha):
	if cha.team == 2:
		sys.main.player.plusGold(3)
		sys.main.player.plusEmp(3)

func _castCdSkill(id):
	if id == "sxpw":
		var eff = Utils.Effect_CreateAoe("sxpw",aiCha.position,Vector2(0,-35))
		yield(reTimer(0.1),"timeout")
		var chas = getCellChas(aiCha.cell,1,1)
		for i in chas:
			masCha.hurtChara(i,att.atk,Chara.HurtType.PHY,Chara.AtkType.SKILL)
			i.addBuff(Buffs.Buff_ArmorDefuseValue.new(60,3))

func DrugThrow():
	aiOn = true
	var chas = getAllChas(1)
	chas.sort_custom(Utils.Sort,"Sort_Threat")
	var eff1 = Utils.Effect_CreateToCha("bwdhhw1", position, chas[0], 400, Vector2(0,-50))
	yield(eff1,"onReach")
	var eff2 = Utils.Effect_CreateAoe("bwdhhw2",chas[0].position)
	var enemys = getCellChas(chas[0].cell,1,1)
	for i in enemys:
		if team == 1:			
			i.addBuff(Buffs.Buff_Stun.new(2 + DrugPreTime))
			hurtChara(i, 200+200*DrugPreTime, Chara.HurtType.MGI, Chara.AtkType.SKILL)
		else:
			i.addBuff(Buffs.Buff_Stun.new(2))
			hurtChara(i, 400, Chara.HurtType.MGI, Chara.AtkType.SKILL)
	masCha.addBuff(b_jiSu.new(8))
