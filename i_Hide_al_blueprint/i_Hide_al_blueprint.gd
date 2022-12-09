extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "科研图纸"
	info = "用于强化科研舰娘的属性，强化后消失\n科研舰娘通过科研系统获得，售卖此物品不能获得金币"
	price = 0
func _connect():
	if masCha.get("isResearch") && masCha.get("level") < 11 and masCha.lv == 4:
		masCha.strengthen()
		yield(masCha.reTimer(0.2),"timeout")
		sys.main.player.delItem(self)
