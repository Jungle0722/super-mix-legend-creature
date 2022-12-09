extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "一式穿甲弹"
	att.atk = 50
	att.penL = 0.3
	att.criR = 0.2
	info = "[color=#DC143C]同时装备三件时可升级[/color]"

func _connect():
	utils.itemUpgrade(self)

var p = 3
var upgraded = false
func upgrade():
	name = "[color=#FFFF00]一式穿甲弹·改"
	info = ""
	att.atk = 100 * relic.equipBonus
	att.penL = 0.5 * relic.equipBonus
	att.criR = 0.6 * relic.equipBonus
	p = 6

