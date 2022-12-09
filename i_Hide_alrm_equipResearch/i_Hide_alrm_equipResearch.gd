extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[特殊]装备研发图纸"
	info = "在装备研发时，放入小卖部装备栏第二格"

var equip
var equipId
func repair(equipId):
	self.equipId = 	equipId
	equip = sys.newItem(equipId)
	var equipName = equip.name.rsplit("[color=#DC143C][")[1].rsplit("]")[1]
	name = "[特殊]研发图纸·%s"%equipName
	info = "可用于[%s]的研发，使用方法请查看[科研系统-帮助说明]"%equipName
