extends "../azurline_ctrl/CAS.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轰炸机」BTD-1毁灭者"   #角色的名称
	addSkillTxt("暴击、爆伤+80%")
	attAdd.cri += 0.8
	attAdd.criR += 0.8
	

