extends "../cazurlineE_4_1/cazurlineE_4_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」无畏·誓约"   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 2
	attCoe.def += 2
	attCoe.mgiDef += 2
	summLimit = 7
	summActiveLimit = 5
	attAdd.cd += 0.3
	addSkill("载机量+2，冷却速度+20%，战斗开始时，额外起飞1架舰载机", "放手一搏")
	addSkillTxt("[color=#C0C0C0][现代化改造]-战斗开始时，额外起飞1架舰载机(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onBattleStart():
	._onBattleStart()
	for i in range(p4):
		castPlane()
var p4 = 1
func upgrade():
	p4 = 2
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")