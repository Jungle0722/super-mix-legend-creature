extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]心智镣铐"
	att.maxHpL = 0.25
	att.def = 100
	att.mgiDef = 100
	price = 300
	info = "战斗开始时，扣除自身双攻，全部转化为血量\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可被科研装备吞噬[/color]"

func _connect():
	._connect()
	sys.main.connect("onBattleStart", self, "onBattleStart")

func onBattleStart():
	if masCha == null or not utils.inBattle(masCha):return
	masCha.addBuff(b_al_heartChains.new())

class b_al_heartChains:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_al_heartChains"	
	func _connect():
		att.maxHp = masCha.att.atk + masCha.att.mgiAtk
		att.atk = -masCha.att.atk
		att.mgiAtk = -masCha.att.mgiAtk