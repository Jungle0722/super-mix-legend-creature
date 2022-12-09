extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "海军迷彩"
	att.maxHp = sys.rndRan(200, 400)
	att.def = 70
	att.mgiDef = 70
	info = "受到普攻时，会赋予攻击者3层<致盲>\n[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()
func _connect():
	masCha.connect("onHurt",self,"run")
	utils.itemUpgrade(self)

func run(atkInfo):
	if atkInfo.atkType == Chara.AtkType.NORMAL and atkInfo.hitCha.team != atkInfo.atkCha.team:
		atkInfo.atkCha.addBuff(utils.buffs.b_blindness.new(p))
	
var p = 3
var upgraded = false
func upgrade():
	name = "[color=#FFFF00]海军迷彩·改"
	info = "受到普攻时，会赋予攻击者6层<致盲>"
	att.maxHp = 600 * relic.equipBonus
	att.def = 140 * relic.equipBonus
	att.mgiDef = 140 * relic.equipBonus
	p = 6
func rare():
	name = "[color=#FF00FF][稀有]海军迷彩"
	att.maxHp = 400
	att.def = 90
	att.mgiDef = 90
