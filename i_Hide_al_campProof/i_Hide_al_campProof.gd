extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[特殊]借调证明"
	info = "阵营特化模式专用，一次性消耗品，可将装备者的阵营永久转化为当前所选阵营\n仅限传奇舰娘使用"
	price = 300

func _connect():
	._connect()
	if masCha == null:return
	if masCha.get("tag") != "azurline" or azurCtrl.campMaster.empty() or masCha.lv != 4:
		delFromCha()
		return	
	masCha.realCamp = azurCtrl.campMaster[0]
	masCha.setCamp(masCha.realCamp)
	delSelf()	