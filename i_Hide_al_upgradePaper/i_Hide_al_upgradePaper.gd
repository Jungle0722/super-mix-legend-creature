extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[稀有]改造蓝图"
	info = "一次性道具，用于对传奇舰娘进行现代化改造，改造后将解锁其隐藏能力\n仅支持对拥有现代化改造描述的舰娘进行改造\n[color=#DC143C]仅能对传奇舰娘进行改造[/color]\n来源：PT商店、击败塞壬"

func _connect():
	if masCha.has_method("upgrade") and masCha.get("upgraded") == false and masCha.lv == 4:
		masCha.upgrade()
		masCha.upgraded = true
		delSelf()