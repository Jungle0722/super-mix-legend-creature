extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "改良锅炉"
	att.atk = sys.rndRan(70, 100)
	att.spd = sys.rndRan(20, 40)/100 as float
	att.dod = sys.rndRan(20, 40)/100 as float
	info = "[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()

func _connect():
	utils.itemUpgrade(self)

var upgraded = false
func upgrade():
	name = "[color=#FFFF00]改良锅炉·改"
	info = ""
	att.atk = 180 * relic.equipBonus
	att.spd = 0.6 * relic.equipBonus
	att.dod = 0.6 * relic.equipBonus
func rare():
	name = "[color=#FF00FF][稀有]改良锅炉"
	info = "[color=#DC143C]同时装备三件时可升级[/color]"
	att.atk = 100
	att.spd = 0.4
	att.dod = 0.4
