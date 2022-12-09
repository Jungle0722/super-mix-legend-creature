extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[color=#FFFF00][神秘]吸血鬼药剂"
	info = "一次性提高舰娘35%物理/法术吸血与20%伤害加成，使用后消失\n[color=#C0C0C0]售卖此物品不能获得金币，也无法通过小卖部以旧换新"
	price = 0
var itemTag = "medic"
func _connect():
	masCha.updateTmpAtt("suck", 0.35)
	masCha.updateTmpAtt("mgiSuck", 0.35)
	masCha.updateTmpAtt("atkR", 0.2)
	delSelf()

	
