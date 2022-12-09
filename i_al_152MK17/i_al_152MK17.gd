extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "试作型三联装152MM炮MK17"
	att.mgiAtk = 100
	info = "本回合内，每次施放技能，提高自身5%法术穿透\n[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()
func _connect():
	masCha.connect("onCastCdSkill",self,"onCastCdSkill")
	utils.itemUpgrade(self)

func onCastCdSkill(id):
	var buff = masCha.hasBuff("b_mgiPenL_p")
	if buff == null:
		masCha.addBuff(utils.buffs.b_mgiPenL.new(p))
	else:
		buff.att.mgiPenL += p*0.1

var p = 0.5
var upgraded = false
func upgrade():
	name = "[color=#FFFF00]试作型三联装152MM炮MK17·改"
	info = "本回合内，每次施放技能，提高自身10%法术穿透"
	att.mgiAtk = 200 * relic.equipBonus
	p = 1

func rare():
	name = "[color=#FF00FF][稀有]试作型三联装152MM炮MK17"
	att.mgiAtk = 125
