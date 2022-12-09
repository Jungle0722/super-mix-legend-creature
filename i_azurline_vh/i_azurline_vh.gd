extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "VH装甲钢板"
	att.maxHp = sys.rndRan(300, 500)
	info = "受到的技能伤害降低30%\n[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()
func _connect():
	masCha.connect("onHurt",self,"run")
	utils.itemUpgrade(self)

func run(atkInfo):
	if atkInfo.atkType == Chara.AtkType.SKILL:
		atkInfo.hurtVal *= p
	
var p = 0.7
var upgraded = false
func upgrade():
	name = "[color=#FFFF00]VH装甲钢板·改"
	info = "受到的技能伤害降低50%"
	att.maxHp = 800 * relic.equipBonus
	p = 0.5
func rare():
	name = "[color=#FF00FF][稀有]VH装甲钢板"
	att.maxHp = 500

