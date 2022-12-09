extends "../azurline_ctrl/fighter.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	attCoe.def += 1
	chaName = "「战斗机」烈风"   #角色的名称
	addSkillTxt("闪避+50%，血上限+20%")
	attAdd.dod += 0.5
	attAdd.maxHpL += 0.2
	


