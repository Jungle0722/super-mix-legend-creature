extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "试作型410MM三联炮"
	att.atk = 50
	att.mgiAtk = 50
	att.cd = 0.2
	info = "造成技能伤害时，附加5层<漏水>\n[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()

func _connect():
	masCha.connect("onAtkChara",self,"onAtkChara")
	utils.itemUpgrade(self)

func onAtkChara(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.SKILL and atkInfo.hitCha.team != atkInfo.atkCha.team:
		utils.buffs.addLouShui(atkInfo.hitCha, masCha, p)

var p = 5
var upgraded = false
func upgrade():
	name = "[color=#FFFF00]试作型410MM三联炮·改"
	att.atk = 100 * relic.equipBonus
	att.mgiAtk = 100 * relic.equipBonus
	att.cd = 0.4 * relic.equipBonus
	info = "造成技能伤害时，附加10层<漏水>"
	p = 10

func rare():
	name = "[color=#FF00FF][稀有]试作型410MM三联炮"
	att.atk = 75
	att.mgiAtk = 75
	att.cd = 0.3
