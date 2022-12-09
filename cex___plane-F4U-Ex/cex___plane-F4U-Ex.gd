extends "../azurline_ctrl/fighter.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	attCoe.maxHp += 3
	chaName = "「战斗机」F4U·VF-17海盗中队"   #角色的名称
	lv = 4             #等级的设置
	addSkillTxt("血量越低，输出、减伤越高")
	
var baseId = ""

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.hurtVal > 0:
		var r = att.hp/att.maxHp
		r = max(r, 0.4)
		atkInfo.hurtVal *= r

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.hurtVal > 0:
		var r = att.hp/att.maxHp
		atkInfo.hurtVal *= (2 - r)