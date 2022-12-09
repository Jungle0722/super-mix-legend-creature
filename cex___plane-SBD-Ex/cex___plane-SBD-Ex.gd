extends "../azurline_ctrl/CAS.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	attCoe.atk += 2
	chaName = "「轰炸机」SBD无畏·麦克拉斯基队"   #角色的名称
	lv = 4             #等级的设置
	addSkillTxt("普攻50%几率再次普攻")
	
var baseId = ""

func normalAtkChara(tcha):
	if sys.rndPer(50):
		normalAtkChara(tcha)
	.normalAtkChara(tcha)