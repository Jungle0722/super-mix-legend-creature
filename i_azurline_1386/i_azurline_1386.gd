extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "138.6mm单装炮"
	att.mgiAtk = 120
	att.mgiSuck = 0.3
	att.cri = 0.3
	info = "[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()

func _connect():
	utils.itemUpgrade(self)
var p = 3
var upgraded = false
func upgrade():
	name = "[color=#FFFF00]138.6mm单装炮·改"
	info = ""
	att.mgiAtk = 240 * relic.equipBonus
	att.mgiSuck = 0.6 * relic.equipBonus
	att.cri = 0.6 * relic.equipBonus
func rare():
	name = "[color=#FF00FF][稀有]138.6mm单装炮"
	att.mgiAtk = 150
	att.mgiSuck = 0.3
	att.cri = 0.3