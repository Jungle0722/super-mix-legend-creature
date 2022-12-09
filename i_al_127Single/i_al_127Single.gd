extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "127MM单装炮"
	att.atk = 100
	att.mgiAtk = 100
	info = "每次施放技能，缩短自身所有技能冷却1秒（对冷却已低于1.5秒的技能不生效）\n[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()
func _connect():
	masCha.connect("onCastCdSkill",self,"onCastCdSkill")
	utils.itemUpgrade(self)

func onCastCdSkill(id):
	if not enable:return
	enable = false
	for j in masCha.skills:
		if j.cd/(1+masCha.att.cd) - j.nowTime > p:
			j.nowTime += p

var enable = true
func _upS():
	enable = true

var p = 1
var upgraded = false
func upgrade():
	name = "[color=#FFFF00]127MM单装炮·改"
	info = "每次施放技能，缩短自身所有技能冷却2秒（对冷却已低于2.5秒的技能不生效）"
	att.mgiAtk = 200 * relic.equipBonus
	att.atk = 200 * relic.equipBonus
	p = 2

func rare():
	name = "[color=#FF00FF][稀有]127MM单装炮"
	info = "每次施放技能，缩短自身所有技能冷却1秒（对冷却已低于1.5秒的技能不生效）\n[color=#DC143C]同时装备三件时可升级[/color]"
	att.atk = 125
	att.mgiAtk = 125