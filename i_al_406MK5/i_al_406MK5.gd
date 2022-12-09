extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "双联406MM主炮MK5"
	att.atk = sys.rndRan(75, 125)
	att.cri = sys.rndRan(15, 35)/100 as float
	att.criR = sys.rndRan(10, 30)/100 as float
	info = "[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"

func _connect():
	utils.itemUpgrade(self)

var upgraded = false
func upgrade():
	name = "[color=#FFFF00]双联406MM主炮MK5·改"
	att.atk = 200 * relic.equipBonus
	att.cri = 0.5 * relic.equipBonus
	att.criR = 0.4 * relic.equipBonus
	info = ""
