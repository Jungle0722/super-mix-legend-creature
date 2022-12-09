extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "双联113mm高射炮"
	att.spd = sys.rndRan(30, 70) /100 as float
	att.cd = 0.2
	info = "造成非普攻伤害时，目标身上每有1层<漏水><烧蚀><霜冻>，提高6%伤害\n[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()
func _connect():
	masCha.connect("onAtkChara",self,"run")
	utils.itemUpgrade(self)
var p = 0.06
var includes = ["b_shaoShi", "b_louShui", "b_freeze"]
func run(atkInfo:AtkInfo):
	if atkInfo.atkType != Chara.AtkType.NORMAL:
		var num = 0
		for i in atkInfo.hitCha.buffs:
			if includes.has(i.id):num += 1
		atkInfo.factor += num * p

var upgraded = false
func upgrade():
	name = "[color=#FFFF00]双联113mm高射炮·改"
	info = "造成非普攻伤害时，目标身上每有1层<漏水><烧蚀><霜冻>，提高12%伤害"
	att.spd = 1 * relic.equipBonus
	att.cd = 0.4 * relic.equipBonus
	p = 0.12

func rare():
	name = "[color=#FF00FF][稀有]双联113mm高射炮"
	att.spd = 0.7
	att.cd = 0.3