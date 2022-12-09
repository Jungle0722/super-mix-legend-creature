extends "../cex___planeBase/cex___planeBase.gd"
func _info():
	pass
func _connect():
	._connect()
	pass
func _extInit():
	._extInit()
	chaName = "通用轰炸机"   #角色的名称
	attCoe.atkRan = 15  #攻击距离
	attCoe.atk += 4
	prefer = "cas"