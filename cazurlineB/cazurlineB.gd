extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「轻巡」夕张"   #角色的名称
	attCoe.atkRan = 1#攻击距离
	attCoe.maxHp = 3#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 4     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 2  #魔法攻击（每点代表13.7）
	attCoe.def = 2     #物理防御（每点代表15）
	attCoe.mgiDef = 2#魔法防御（每点代表16.6）
	lv = 1             #等级的设置
	atkEff = "atk_dao" #攻击时的特效
	evos = ["cazurlineB_1","cazurlineB_2","cazurlineB_3","cazurlineB_4","cazurlineB_5","cazurlineB_6","cazurlineB_7"]
	if id == "cazurlineB":
		addSkill("平平无奇的轻巡阵营基础单位", "轻巡洋舰")
	type = "cl"
	setGunAndArmor("小型","轻型")
	prefer = "ad"
	setCamp("重樱")


func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "先进火控":
		return att.atk * (0.3 + att.dod)
	elif name == "神圣新星":
		return att.mgiAtk*2.5
	elif name == "海之女神":
		return att.atk*2
	elif name == "所罗门传说":
		return att.atk*4
	elif name == "精准诱导":
		return att.mgiAtk*1.5
	elif name == "审判":
		return att.atk*5
	elif name == "快速射击":
		return att.atk*0.6
	elif name == "战斗之星":
		return att.atk*2
	elif name == "重击冰魄":
		return att.atk*2