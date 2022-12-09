extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]觉醒宝珠"
	info = "特效1：若佩戴者为μ兵装舰娘，则使其提前获得所有羁绊加成\n特效2：若佩戴者拥有<亡语>技能，则每8秒触发其亡语效果\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效2可被科研装备吞噬"
	price = 300
	att.atk = 100
	att.mgiAtk = 100
	att.def = 100
	att.mgiDef = 100
	
func _connect():
	._connect()
	sys.main.connect("onBattleEnd",self,"end")

var num = 0
func _upS():
	._upS()
	if masCha == null:return
	num += 1
	if num >= 8:
		if masCha.has_method("deathWord"):
			masCha.deathWord()
		num = 0

func end():
	num = 0