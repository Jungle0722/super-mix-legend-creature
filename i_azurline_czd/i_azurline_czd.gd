extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "超重弹"
	att.mgiAtk = 80
	att.mgiPenL = 0.3
	att.criR = 0.3
	info = "[color=#DC143C]同时装备三件时可升级[/color]"
func _connect():
	utils.itemUpgrade(self)
var upgraded = false
func upgrade():
	name = "[color=#FFFF00]超重弹·改"
	info = ""
	att.mgiAtk = 160 * relic.equipBonus
	att.mgiPenL = 0.5 * relic.equipBonus
	att.criR = 0.6 * relic.equipBonus