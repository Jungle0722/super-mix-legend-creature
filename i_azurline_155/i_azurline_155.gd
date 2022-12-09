extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "155MM三连装炮"
	att.atkRan = 3
	att.atk = 80
	att.cri = 0.3
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()
	
func _connect():
	utils.itemUpgrade(self)

var upgraded = false
func upgrade():
	name = "[color=#FFFF00]155MM三连装炮·改"
	att.atkRan = 6 * relic.equipBonus
	att.atk = 160 * relic.equipBonus
	att.cri = 0.6 * relic.equipBonus

func rare():
	name = "[color=#FF00FF][稀有]155MM三连装炮"
	att.atkRan = 4
	att.atk = 120
	att.cri = 0.4
