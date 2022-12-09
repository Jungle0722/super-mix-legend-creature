extends "../cazurlineF_2_2/cazurlineF_2_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「辅助」明石·快修型"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 3
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("治疗血量低于50%的角色时，治疗量翻倍", "快速修理")

	addSkillTxt("[color=#C0C0C0][现代化改造]-后勤维修治疗量降低50%，但会对全体友军生效(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func healCha(cha, num, rate = 1):
	if cha.att.hp/cha.att.maxHp <= 0.5:
		num *= 2
	.healCha(cha, num, 1)
