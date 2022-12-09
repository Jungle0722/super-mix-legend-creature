extends "../cex___al-commander3/cex___al-commander3.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「元帅」舰队指挥官"   #角色的名称
	lv = 4
	attCoe.maxHp += 1
	attCoe.atk += 1
	attCoe.mgiAtk += 1
	attCoe.def += 1
	attCoe.mgiDef += 1

var baseId = ""
