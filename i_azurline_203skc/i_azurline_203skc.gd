extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "双联203mmSKC主炮"
	att.atk = 100
	att.spd = 0.5
	info = "普攻额外造成目标最大生命值6%的物理伤害\n[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()
func _connect():
	masCha.connect("onAtkChara",self,"run")
	utils.itemUpgrade(self)
var p = 0.06
func run(atkInfo):
	if atkInfo.atkType == Chara.AtkType.NORMAL and atkInfo.hitCha.team != atkInfo.atkCha.team:
		if masCha.get("tag") == "azurline":
			masCha.azurHurtChara(atkInfo.hitCha, min(50000, atkInfo.hitCha.att.maxHp)*p, Chara.HurtType.PHY,Chara.AtkType.EFF, "双联203mmSKC主炮")
		else:
			masCha.hurtChara(atkInfo.hitCha, min(50000, atkInfo.hitCha.att.maxHp)*p, Chara.HurtType.PHY,Chara.AtkType.EFF)

var upgraded = false
func upgrade():
	name = "[color=#FFFF00]双联203mmSKC主炮·改"
	info = "普攻额外造成目标最大生命值12%的物理伤害"
	att.atk = 200 * relic.equipBonus
	att.spd = 1 * relic.equipBonus
	p = 0.12
func rare():
	name = "[color=#FF00FF][稀有]双联203mmSKC主炮"
	att.atk = 125
	att.spd = 0.5
