extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]改良声呐"
	info = "受到攻击后，赋予攻击者2层<暴露>\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可以被科研装备吞噬[/color]"
	price = 300
	att.atk = 100
	att.mgiAtk = 100
	att.def = 100
	att.mgiDef = 100
	att.dod = 0.3
	
func _connect():
	._connect()
	masCha.connect("onHurt",self,"onHurt")

func onHurt(atkInfo):
	if atkInfo.atkCha.team != masCha.team:
		buffUtil.addBaoLu(atkInfo.atkCha, 2)
