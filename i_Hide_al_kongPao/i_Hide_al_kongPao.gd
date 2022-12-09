extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]超空泡发生器"
	info = "对塞壬造成的伤害提高50%\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可被科研装备吞噬[/color]"
	price = 300
	att.atk = 100
	att.mgiAtk = 100
	att.cri = 0.25
	att.criR = 0.25
	
func _connect():
	._connect()
	masCha.connect("onAtkChara",self,"run")

func run(atkInfo):
	if atkInfo.hitCha.get("type") == "BOSS":
		atkInfo.factor += 0.5
