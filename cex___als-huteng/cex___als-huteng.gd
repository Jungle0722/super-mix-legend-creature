extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」胡滕"   #角色的名称
	attCoe.atkRan = 5#攻击距离
	attCoe.atk += 2     #攻击力（每点代表8.5）
	lv = 3             #等级的设置
	evos = ["cex___als-huteng2"]
	addSkill("每次普攻对当前目标及其周围(九宫格)的敌人造成一次[攻击*1]({damage})的可暴击技能伤害", "铁血弹幕")
	addSkill("本回合普攻暴击后，提高20%暴伤(上限600%)，若未暴击，则失去所有累积的爆伤", "深海狂暴")
	ename = "huteng"
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("铁血")
	canCopy = false
var bf
func _onBattleStart():
	._onBattleStart()
	bf = addBuff(b_huteng.new())

func _onNormalAtk(cha):
	for i in getAroundChas(cha.cell, false):
		azurHurtChara(i, getSkillEffect("铁血弹幕"), Chara.HurtType.PHY, Chara.AtkType.SKILL, "铁血弹幕", true)

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		if bf == null:
			bf = addBuff(b_huteng.new())
		if atkInfo.isCri:
			if bf.att.criR < 6:
				bf.att.criR += 0.2
		else:
			bf.att.criR = 0
		
class b_huteng:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_huteng"

func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "铁血弹幕":
		return att.atk
	elif name == "终结一击":
		return att.atk * 1
