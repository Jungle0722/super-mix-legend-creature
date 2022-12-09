extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]纳米陶铝合金"
	info = "减免60%所受普攻伤害\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效无法被科研装备吞噬[/color]"
	price = 300
	att.def = 80
	att.mgiDef = 80
	att.maxHp = 400
	
func _connect():
	._connect()
	masCha.connect("onHurt",self,"onHurt")

func onHurt(atkInfo):
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		atkInfo.hurtVal *= 0.4