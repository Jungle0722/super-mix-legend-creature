extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[特殊]心智魔方"
	info = "放入小卖部，可进行一次5连建造(有几率获得特殊舰娘)"
	price = 300
#佩戴者
var cha = null
func _connect():
	if masCha.id == "cex___al-merchant":
		utils.rollItem(0, 5)
		yield(masCha.reTimer(0.1), "timeout")
		sys.main.player.delItem(self)