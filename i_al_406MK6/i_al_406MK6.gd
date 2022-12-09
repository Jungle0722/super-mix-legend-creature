extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "三联406MM主炮MK6"
	att.atk = 60
	att.mgiAtk = 60
	att.suck = 0.4
	att.mgiSuck = 0.4
	info = "使自己造成的所有非普攻伤害均能触发吸血(吸血系数为自身物理吸血+法术吸血)\n[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()

func _connect():
	utils.itemUpgrade(self)
	masCha.connect("onAtkChara",self,"onAtkChara")

func onAtkChara(atkInfo:AtkInfo):
	if atkInfo.atkType != Chara.AtkType.NORMAL and masCha.get("type") != "BOSS":
		masCha.plusHp(atkInfo.hurtVal * (masCha.att.suck + masCha.att.mgiSuck))

var upgraded = false
func upgrade():
	name = "[color=#FFFF00]三联406MM主炮MK6·改"
	att.atk = 120 * relic.equipBonus
	att.mgiAtk = 120 * relic.equipBonus
	att.suck = 0.8 * relic.equipBonus
	att.mgiSuck = 0.8 * relic.equipBonus
	info = "使自己造成的所有非普攻伤害均能触发吸血(吸血系数为自身物理吸血+法术吸血)"

func rare():
	name = "[color=#FF00FF][稀有]三联406MM主炮MK6"
	att.atk = 80
	att.mgiAtk = 80
	att.suck = 0.55
	att.mgiSuck = 0.55
	info = "使自己造成的所有非普攻伤害均能触发吸血(吸血系数为自身物理吸血+法术吸血)\n[color=#DC143C]同时装备三件时可升级[/color]"
