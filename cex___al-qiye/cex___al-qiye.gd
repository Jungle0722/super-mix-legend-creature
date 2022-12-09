extends "../cazurlineE_2_1_1/cazurlineE_2_1_1.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「航母」企业·Meta·Lv%d"%level   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 2
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___al-qiye2"]
	if id == "cex___al-qiye":
		addSkillTxt("[color=#C0C0C0]参加18场战斗后，将进化为传奇单位[/color]")
	type = "siren"
	canCopy = false
	setCamp("塞壬")
	
func levelUp():
	.levelUp()
	updateAtt()

func updateAtt():
	updateTmpAtt("maxHp", 100, false)
	updateTmpAtt("atk", 10, false)
	updateTmpAtt("mgiAtk", 15, false)
	updateTmpAtt("def", 10, false)
	updateTmpAtt("mgiDef", 10, false)
	if level == 20 and gSiren.sirenAwaken:
		call("awaken")
		updateTmpAtt("maxHp", 1500, false)
		updateTmpAtt("atk", 100, false)
		updateTmpAtt("mgiAtk", 150, false)
		updateTmpAtt("def", 100, false)
		updateTmpAtt("mgiDef", 100, false)
	upAtt()
