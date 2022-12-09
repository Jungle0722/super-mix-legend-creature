extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「战列」科罗拉多"   #角色的名称
	attCoe.atkRan = 1#攻击距离
	attCoe.maxHp = 3#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 3     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 2  #魔法攻击（每点代表13.7）
	attCoe.def = 4     #物理防御（每点代表15）
	attCoe.mgiDef = 4#魔法防御（每点代表16.6）
	lv = 1             #等级的设置
	atkEff = "atk_dang" #攻击时的特效
	evos = ["cazurlineD_1","cazurlineD_2","cazurlineD_3","cazurlineD_4","cazurlineD_5","cazurlineD_6"]
	if id == "cazurlineD":
		addSkill("平平无奇的战列阵营基础单位", "战列舰")
	type = "bb"
	setGunAndArmor("大型","重型")
	prefer = "ad"
	setCamp("白鹰")

func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "神射手·改":
		return att.atk * 0.5
	elif name == "装甲碾压":
		return att.atk * 1.6
	elif name == "战略威慑":
		return att.maxHp * 0.05
	elif name == "存在舰队学说":
		return att.maxHp * 0.1
	elif name == "永夜晨光":
		return (att.atk + att.mgiAtk + att.def + att.mgiDef)*2
		