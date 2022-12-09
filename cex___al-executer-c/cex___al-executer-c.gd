extends "../azurline_ctrl/Siren.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「塞壬」代行者IX·Lv%d"%level    #角色的名称
	lv = 3             #等级的设置
	attCoe.atkRan = 4#攻击距离
	attCoe.maxHp = 5#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 4     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 4  #魔法攻击（每点代表13.7）
	attCoe.def = 4     #物理防御（每点代表15）
	attCoe.mgiDef = 4#魔法防御（每点代表16.6）
	atkEff = "atk_gongJian" #攻击时的特效
	evos = ["cex___al-executer-c2"]
	addSkill("每{cd}秒降低所有敌人10%的四维", "逆风", "niFeng", 15)
	addSkill("降低50%所受技能伤害", "绝缘")
	if id == "cex___al-executer-c":
		addSkillTxt("[color=#C0C0C0]参加18场战斗后，将进化为传奇单位[/color]")
	
func levelUp():
	.levelUp()
	updateAtt()
	
func updateAtt():
	updateTmpAtt("maxHp", 150, false)
	updateTmpAtt("def", 15, false)
	updateTmpAtt("mgiDef", 15, false)
	if level == 20 and gSiren.sirenAwaken:
		call("awaken")
		updateTmpAtt("maxHp", 1500, false)
		updateTmpAtt("def", 100, false)
		updateTmpAtt("mgiDef", 100, false)
	upAtt()

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "niFeng":
		niFeng()
		
func niFeng():
	for i in getAllChas(1):
		var bf = i.hasBuff("b_executer_c")
		if bf == null:
			i.addBuff(b_executer_c.new())
		else:
			bf.add()
var p2 = 0.5
func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkType == Chara.AtkType.SKILL:
		atkInfo.hurtVal *= p2
		healCha(self, att.maxHp * 0.05)

class b_executer_c:
	extends Buff
	var buffName = "逆风"
	var dispel = 2
	func _init():
		attInit()
		id = "b_executer_c"
		isNegetive = true
		att.atkL = -0.1
		att.mgiAtkL = -0.1
		att.defL = -0.1
		att.mgiDefL = -0.1
	func add():
		if att.atkL > -0.5 and masCha.att.atk > 0:
			att.atkL -= 0.1
		if att.mgiAtkL > -0.5 and masCha.att.mgiAtk > 0:
			att.mgiAtkL -= 0.1
		if att.defL > -0.5 and masCha.att.def > 0:
			att.defL -= 0.1
		if att.mgiDefL > -0.5 and masCha.att.mgiDef > 0:
			att.mgiDefL -= 0.1	

