extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "试作型三联203MM主炮"
	att.atkRan = 2
	att.spd = 0.4
	info = "普攻附加3层<烧蚀>且获得3层[急速]\n[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()

func _connect():
	masCha.connect("onAtkChara",self,"onAtkChara")
	utils.itemUpgrade(self)

func onAtkChara(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		masCha.addBuff(utils.buffs.b_jiSu_r.new(p))
		if atkInfo.hitCha.team != atkInfo.atkCha.team:
			atkInfo.hitCha.addBuff(utils.buffs.b_shaoShi.new(p, masCha))
var p = 3
var upgraded = false
func upgrade():
	name = "[color=#FFFF00]试作型三联203MM主炮·改"
	att.atkRan = 4 * relic.equipBonus
	att.spd = 0.8 * relic.equipBonus
	p = 6
	info = "普攻附加6层<烧蚀>且获得6层[急速]"

func rare():
	name = "[color=#FF00FF][稀有]试作型三联203MM主炮"
	att.atkRan = 2
	att.spd = 0.5
