extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「重巡」萨福克"   #角色的名称
	attCoe.atkRan = 1#攻击距离
	attCoe.maxHp = 5#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 4     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 3  #魔法攻击（每点代表13.7）
	attCoe.def = 2     #物理防御（每点代表15）
	attCoe.mgiDef = 2#魔法防御（每点代表16.6）
	lv = 1             #等级的设置
	atkEff = "atk_dang" #攻击时的特效
	evos = ["cazurlineC_1","cazurlineC_2","cazurlineC_3","cazurlineC_4","cazurlineC_5","cazurlineC_6"]
	if id == "cazurlineC":
		addSkill("平平无奇的重巡阵营基础单位", "重巡洋舰")
	type = "ca"
	setGunAndArmor("中型","中型")
	prefer = "ad"
	setCamp("皇家")

func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "十字斩":
		return att.atk * 1
	elif name == "不破之盾":
		return att.maxHp * 0.04
	elif name == "动能打击":
		return att.atk * 4
	elif name == "玉石俱焚":
		return att.atk * 10
	elif name == "雷霆一击":
		return att.atk * 2
	elif name == "爆反装甲":
		return (att.def + att.mgiDef)*0.3
