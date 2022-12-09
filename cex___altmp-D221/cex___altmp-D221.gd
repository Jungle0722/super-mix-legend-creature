extends "../cazurlineB_2_1/cazurlineB_2_1.gd"
func _info():
	pass
func _connect():
	._connect()
var summoner
func _extInit():
	._extInit()
	chaName = "「巡洋」神通·镜像"   #角色的名称
	isSumm = true
	lv = 4             #等级的设置
	attCoe.atk += 1
	attCoe.maxHp += 1

var baseId = ""