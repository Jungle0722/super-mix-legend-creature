extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "试作型双联406MM主炮"
	att.atk = 85
	att.penL = 0.2
	att.cd = 0.3
	info = "[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()

func _connect():
	utils.itemUpgrade(self)
				
var upgraded = false
func upgrade():
	name = "[color=#FFFF00]试作型双联406MM主炮·改"
	att.atk = 170 * relic.equipBonus
	att.penL = 0.4 * relic.equipBonus
	att.cd = 0.6 * relic.equipBonus

func rare():
	att.atk = 100
	att.penL = 0.25
	att.cd = 0.4