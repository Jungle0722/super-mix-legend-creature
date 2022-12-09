extends "../cex___als-h39/cex___als-h39.gd"
func _info():
	pass
var baseId = ""
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「战列」腓特烈大帝"
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）

	addSkillTxt("[color=#C0C0C0][现代化改造]-破坏交响曲伤害系数提高15%，可触发吸血效果(未解锁)")
	lv = 4
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func upgrade():
	p4 = 0.45
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
