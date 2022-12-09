extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]雷锋帽"
	att.maxHpL = 0.1
	info = "<唯一>战斗开始后，将自身四维属性的40%平分给周围(十字范围)的友军\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效无法被科研装备吞噬[/color]"
	price = 300
	
func _connect():
	._connect()
	for i in masCha.items:
		if i.id == id && i != self:
			delFromCha()
			return
	sys.main.connect("onBattleStart", self, "onBattleStart")

func onBattleStart():
	var chas = masCha.getCellChas(masCha.cell, 1, 2)
	chas.erase(masCha)
	if chas.empty():return
	var atk = masCha.att.atk * 0.4 / chas.size()
	var mgiAtk = masCha.att.mgiAtk * 0.4 / chas.size()
	var def = masCha.att.def * 0.4 / chas.size()
	var mgiDef = masCha.att.mgiDef * 0.4 / chas.size()
	for i in chas:
		if i.hasBuff("b_greenHat") == null:
			i.addBuff(b_greenHat.new(atk, mgiAtk, def, mgiDef))
	masCha.addBuff(b_greenHat.new(-masCha.att.atk * 0.4, -masCha.att.mgiAtk * 0.4, -masCha.att.def * 0.4, -masCha.att.mgiDef * 0.4))
	
class b_greenHat:
	extends Buff
	var buffName = "雷锋帽"
	var dispel = 2
	func _init(atk, mgiAtk, def, mgiDef):
		attInit()
		id = "b_greenHat"	
		att.atk = atk
		att.mgiAtk = mgiAtk
		att.def = def
		att.mgiDef = mgiDef
