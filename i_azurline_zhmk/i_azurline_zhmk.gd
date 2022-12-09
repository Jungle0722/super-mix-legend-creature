extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "智慧模块\n[color=#DC143C]同时装备三件时可升级[/color]"
	att.mgiAtk = 120
	att.mgiAtkL = 0.2
	
var upgraded = false
func upgrade():
	name = "[color=#FFFF00]智慧模块·改"
	att.mgiAtk = 300 * relic.equipBonus
	att.mgiAtkL = 0.4 * relic.equipBonus

func _connect():
	utils.itemUpgrade(self)

	
