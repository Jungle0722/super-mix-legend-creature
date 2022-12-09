extends "../cex___al-commander/cex___al-commander.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「少校」舰队指挥官"   #角色的名称
	lv = 2
	evos = ["cex___al-commander3"]
	attCoe.maxHp += 1
	attCoe.atk += 1
	attCoe.mgiAtk += 1
	attCoe.def += 1
	attCoe.mgiDef += 1