extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "防鱼雷隔仓"
	att.maxHp = 500
	att.def = 60
	att.mgiDef = 60
	info = "受到暴击时，减少50%所受伤害\n[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()
func _connect():
	masCha.connect("onHurt",self,"run")
	utils.itemUpgrade(self)
func run(atkInfo):
	if atkInfo.isCri:
		atkInfo.hurtVal *= p
	
var p = 0.5
var upgraded = false
func upgrade():
	name = "[color=#FFFF00]防鱼雷隔仓·改"
	info = "受到暴击时，减少75%所受伤害"
	att.maxHp = 1000 * relic.equipBonus
	att.def = 120 * relic.equipBonus
	att.mgiDef = 120 * relic.equipBonus
	p = 0.25
func rare():
	name = "[color=#FF00FF][稀有]防鱼雷隔仓"
	att.maxHp = 600
	att.def = 80
	att.mgiDef = 80
	p = 0.35