extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "双联127mm高平两用炮"
	att.mgiAtk = 120
	att.cri = sys.rndRan(5, 15)/100 as float
	info = "技能命中敌方单位时，赋予目标7层<烧蚀>\n[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()
	
func _connect():
	masCha.connect("onAtkChara",self,"run")
	utils.itemUpgrade(self)
var data = null
func run(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.SKILL and atkInfo.hitCha.team != atkInfo.atkCha.team: 
		atkInfo.hitCha.addBuff(utils.buffs.b_shaoShi.new(p, masCha))

var upgraded = false
var p = 7
func upgrade():
	name = "[color=#FFFF00]双联127mm高平两用炮·改"
	info = "技能命中敌方单位时，赋予目标14层<烧蚀>"
	att.mgiAtk = 240 * relic.equipBonus
	att.cri = 0.2 * relic.equipBonus
	p = 14

func rare():
	name = "[color=#FF00FF][稀有]双联127mm高平两用炮"
	att.mgiAtk = 150
	att.cri = 0.15
