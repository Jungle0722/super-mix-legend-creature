extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "双联381mm主炮"
	att.atk = 60
	att.mgiAtk = 60
	info = "战斗开始后，每秒提升8%攻速，上限200%\n[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()
func _connect():
	utils.itemUpgrade(self)

func _upS():
	if masCha == null || not utils.inBattle(masCha):return
	if masCha.hasBuff("b_spd_incr") == null:
		masCha.addBuff(b_spd_incr.new(p1, p2))

class b_spd_incr:
	extends Buff
	var dispel = 2
	var p1 = 0.1
	var p2 = 20
	func _init(p1 = 0.1, p2 = 20):
		attInit()
		id = "b_spd_incr"
		self.p1 = p1
		self.p2 = p2
	var num = 0
	func _upS():
		num += 1
		if num > p2:
			num = p2
		att.spd = p1*num
var p1 = 0.08
var p2 = 20
var upgraded = false
func upgrade():
	name = "[color=#FFFF00]双联381mm主炮·改"
	info = "战斗开始后，每秒提升16%攻速，上限300%"
	att.atk = 120 * relic.equipBonus
	att.mgiAtk = 120 * relic.equipBonus
	p1 = 0.16
	p2 = 30
func rare():
	name = "[color=#FF00FF][稀有]双联381mm主炮"
	att.atk = 70
	att.mgiAtk = 70