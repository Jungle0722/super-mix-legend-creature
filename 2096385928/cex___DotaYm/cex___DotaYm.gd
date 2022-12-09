extends Chara
const Utils = globalData.infoDs["g_aDotaProcess"]
const Buffs = globalData.infoDs["g_BuffList"]

#覆盖的初始化
func _info():
	pass
#继承的初始化，技能描述在这里写，保留之前的技能描述
func _extInit():
	._extInit()#保留继承的处理
	chaName = "影魔 - 传说"
	attCoe.atkRan = 3
	attCoe.maxHp = 6
	attCoe.atk = 8
	attCoe.mgiAtk = 0
	attCoe.def = 1
	attCoe.mgiDef = 6
	lv = 4
	evos = [] #可以升级到的生物id
	atkEff = "atk_dao"
	addSkillTxt("[color=#FF0000][b]敏捷[/b]：这个单位的攻击速度会随着攻击力提升而提升\n")
	addSkillTxt("毁灭阴影：每3秒，对所有敌方单位造成200%物理攻击的物理伤害。")
	addCdSkill("ym",3)
	addSkillTxt("魔王降临：全场敌方单位减少50点护甲")
	addSkillTxt("支配死灵：每击杀一个单位会收集其灵魂，每个灵魂会提升毁灭阴影5点伤害")
	addSkillTxt("魂之挽歌：死亡时释放支配的灵魂，被灵魂触及的单位受到10*死灵数量的真实伤害，并且被减少50%的攻击速度，持续4秒")
	addSkillTxt("正在哀嚎的死灵数：")
#进入战斗初始化，事件连接在这里初始化

var baseId = ""
var Soul = 0
var Text = "正在哀嚎的死灵数：{Souls}"

func _connect():
	._connect() #保留继承的处理

func _onBattleStart():
	addBuff(Buffs.Buff_Talnet.new(Buffs.AGILITY))
	var chas = getAllChas(1)
	for cha in chas:
		cha.addBuff(Dt_MWJL_ArmorDefuse.new())

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "ym":
		var chas = getAllChas(1)
		chas.sort_custom(self, "sort")
		var i = 0
		for cha in chas:
			ex(cha)

func _onKillChara(atkInfo):
	print(Text.format({"Souls":Soul}))
	Soul += 1
	skillStrs[5] = Text.format({"Souls":Soul})

func sort(a,b):
	if cellRan(a.cell, cell) < cellRan(b.cell, cell):
		return true
	return false

func ex(cha):
	var eff = Utils.Effect_CreateAoe("hmyy",cha.position,Vector2(0,-50))
	hurtChara(cha, (att.atk*2) + (Soul*5), Chara.HurtType.PHY, AtkType.SKILL)

func _onCharaDel(cha):
	if cha == self:
		var Vector = [Vector2(0,200),Vector2(300,0),Vector2(700,200),Vector2(300,400),Vector2(0,0),Vector2(0,400),Vector2(700,0),Vector2(700,400)]
		for i in Vector:
			exDeath(i)

func exDeath(Vector):
	var eff = Utils.Effect_CreateToPos("hzwg",position,Vector,400)
	eff.connect("onInCell",self,"effInCell")

func effInCell(cell):
	var cha = matCha(cell)
	if cha != null && cha.team != team :
		hurtChara(cha, Soul*10, Chara.HurtType.REAL, AtkType.SKILL)
		cha.addBuff(Buffs.Buff_AtkSpeedDefuse.new(0.5,4))

class Dt_MWJL_ArmorDefuse extends Buff:
	func _init(lv=1):
		attInit()
		att.def -= 50
		effId = "p_liuXue"
		id = "Dt_MWJL_ArmorDefuse"
		isNegetive=true

