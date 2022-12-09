extends "../cex___al-ayanami2/cex___al-ayanami2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」绫波·Lv4"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 4     #攻击力（每点代表8.5））
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("挥舞40米斩舰大刀，对周围2格的敌人造成造成[攻击*4]({damage})的可暴击普攻伤害，并摧毁其装甲，\n			使其减少30%护甲，无法驱散或叠加", "鬼神演舞")
	addSkillTxt("[color=#C0C0C0][现代化改造]-鬼神演舞伤害翻倍(未解锁)")
	addSkillTxt("[color=#C0C0C0]在不断的演舞中，绫波逐渐有了新的领悟...")
	if upgraded:
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()	
func upgrade():
	p4 = 8
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
var baseId = ""

func awaken(msg = true):
	chaName = "「驱逐」绫波·觉醒"
	addSkill("鬼神演舞若只命中一人，则造成真实伤害且伤害翻倍", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "绫波已经获得了心智觉醒！")
	isAwaken = true