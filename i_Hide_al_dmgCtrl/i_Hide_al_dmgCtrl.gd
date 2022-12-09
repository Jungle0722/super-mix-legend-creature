extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]精锐损管小组"
	info = "战斗开始时，使佩戴者治疗效果+100%\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效不能被科研装备吞噬[/color]"
	att.atk = 200
	att.mgiAtk = 200
func _connect():
	._connect()
	if masCha.get("tag") != "azurline":
		delSelf()
		return
	sys.main.connect("onBattleStart",self,"start")

func start():
	if masCha != null:
		masCha.addBuff(b_al_dmgCtrl.new())

class b_al_dmgCtrl:
	extends Buff
	func _init():
		attInit()
		id = "b_al_dmgCtrl"	
	func _connect():
		masCha.healHpL += 1
	func _del():
		._del()
		masCha.healHpL -= 1