extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[特殊]定点观瞄设备"
	info = "使用者射程永久锁定为1\n[color=#C0C0C0]一次性消耗品"
	price = 0
var itemTag = "tmp"
func _connect():
	masCha.attFx.atkRan = 1
	masCha.upAtt()
	delSelf()

	
