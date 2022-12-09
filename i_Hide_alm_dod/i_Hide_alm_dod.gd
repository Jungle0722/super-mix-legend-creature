extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[color=#FFFF00][神秘]轻盈药剂"
	info = "一次性提高舰娘35%闪避与攻速，使用后消失\n[color=#C0C0C0]售卖此物品不能获得金币，也无法通过小卖部以旧换新"
	price = 0
var itemTag = "medic"
func _connect():
	masCha.updateTmpAtt("dod", 0.35)
	masCha.updateTmpAtt("spd", 0.35)
	delSelf()

	
