extends Chara
const Utils = globalData.infoDs["g_aDotaProcess"]
const Buffs = globalData.infoDs["g_BuffList"]
#覆盖的初始化
func _info():
	pass
#继承的初始化，技能描述在这里写，保留之前的技能描述
func _extInit():
	._extInit()#保留继承的处理
	chaName = "影魔 - 2级"
	attCoe.atkRan = 2
	attCoe.maxHp = 3
	attCoe.atk = 7
	attCoe.mgiAtk = 0
	attCoe.def = 1
	attCoe.mgiDef = 4
	lv = 2
	evos = ["c_ym_2"] #可以升级到的生物id
	atkEff = "atk_dao"
	addSkillTxt("[color=#FF0000][b]敏捷[/b]：这个单位的攻击速度会随着攻击力提升而提升\n")
	addSkillTxt("毁灭阴影：每3秒，对最近三个单位造成100%物理攻击的物理伤害。")
	addCdSkill("ym",3)
	addSkillTxt("魔王降临：全场敌方单位减少30点护甲")
#进入战斗初始化，事件连接在这里初始化

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
			i += 1
			if i == 3:
				break

func sort(a,b):
	if cellRan(a.cell, cell) < cellRan(b.cell, cell):
		return true
	return false

func ex(cha):
	var eff = Utils.Effect_CreateAoe("hmyy",cha.position,Vector2(0,-50))
	hurtChara(cha, att.atk, Chara.HurtType.PHY, AtkType.SKILL)

class Dt_MWJL_ArmorDefuse extends Buff:
	func _init(lv=1):
		attInit()
		att.def -= 30
		effId = "p_liuXue"
		id = "Dt_MWJL_ArmorDefuse"
		isNegetive=true

		