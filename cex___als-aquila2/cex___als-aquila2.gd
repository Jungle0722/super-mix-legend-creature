extends "../cex___als-aquila/cex___als-aquila.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」天鹰·改"   #角色的名称
	attCoe.atkRan = 3
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	ename = "tianying"
	summLimit = 2
	addSkill("自身舰载机完全继承成长属性，但机库容量降低至2", "星辰之光")

	addSkillTxt("[color=#C0C0C0][现代化改造]-无限试验系数提高至55%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	p3 = 0.55
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

