extends "../cex___al-tester/cex___al-tester.gd"
func _info():
	pass
func _connect():
	._connect()
var baseId = ""
func _extInit():
	._extInit()
	chaName = "「塞壬」测试者α型·Lv%d"%level   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 3	#物理防御（每点代表15）
	attCoe.mgiDef += 3  #魔法防御（每点代表16.6）
	addSkill("每次施放技能，恢复自身10%血量并对自身周围2格的敌人造成[自身血上限40%]的魔法伤害", "施法测试")
	addSkillTxt("[color=#C0C0C0]每次参加战斗即可积累经验，以提升战斗等级，升级可全方位提升实力[/color]")
	addSkillTxt("[color=#C0C0C0][现代化改造]-防御测试伤害提高100%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()
		
func awaken(msg = true):
	isAwaken = true
	addSkillTxt("[color=#C0C0C0][心智觉醒]-施法测试伤害提高100%")
	p4 = 0.8
	
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	p2 = 4