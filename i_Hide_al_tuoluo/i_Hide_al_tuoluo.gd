extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]陀螺仪"
	att.atk = 100
	att.suck = 0.4
	att.mgiDef = 100
	price = 300
	info = "<唯一>战斗开始时提高80%闪避，每秒减少2%\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可以被科研装备吞噬[/color]"
	
func _upS():
	if masCha == null || not utils.inBattle(masCha):return
	if masCha.hasBuff("b_al_tuoluoyi") == null:
		masCha.addBuff(b_al_tuoluoyi.new(0.8))

class b_al_tuoluoyi:
	extends Buff
	var buffName = "陀螺仪"
	var dispel = 2 
	func _init(p):
		attInit()
		id = "b_al_tuoluoyi"
		att.dod = p
	func _upS():
		if att.dod > 0:
			att.dod -= 0.02
	