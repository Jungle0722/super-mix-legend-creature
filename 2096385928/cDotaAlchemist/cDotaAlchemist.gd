extends Chara
const Utils = globalData.infoDs["g_aDotaProcess"]
const Buffs = globalData.infoDs["g_BuffList"]
#覆盖的初始化
func _info():
	pass
#继承的初始化，技能描述在这里写，保留之前的技能描述
func _extInit():
	._extInit()#保留继承的处理
	chaName = "炼金术士 - 1级"
	attCoe.atkRan = 1
	attCoe.maxHp = 4
	attCoe.atk = 3
	attCoe.mgiAtk = 2
	attCoe.def = 3
	attCoe.mgiDef = 3
	lv = 1
	evos = ["ym_1"] #可以升级到的生物id
	atkEff = "atk_dao"
	addCdSkill("sxpw",5)
	addSkillTxt("[color=#FF0000][b]力量[/b]：这个单位攻击造成基于自身最大生命值的物理伤害\n")
	addSkillTxt("贪魔的贪婪：场上敌方单位死亡时额外获得3经验和3金币")
	addSkillTxt("酸性喷雾：每5秒向区域喷洒高压喷雾，造成100%攻击力的物理伤害并削弱30护甲，持续3秒")

#进入战斗初始化，事件连接在这里初始化
func _connect():
	._connect() #保留继承的处理

func _onBattleStart():
	addBuff(Buffs.Buff_Talnet.new(Buffs.POWER))

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
			i.addBuff(Buffs.Buff_ArmorDefuseValue.new(30,3))
