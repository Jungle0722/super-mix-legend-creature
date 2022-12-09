extends "../cex___alcamp-zeppelin/cex___alcamp-zeppelin.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」齐柏林伯爵·改"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 3
	lv = 4             #等级的设置
	addSkill("战斗开始时，额外召唤一架舰载机，自身舰载机获得短兵相接技能", "铁血之翼")

	addSkillTxt("[color=#C0C0C0][现代化改造]-短兵相接回血量提高50%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	p3 = 0.3
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onBattleStart():
	._onBattleStart()
	castPlane()