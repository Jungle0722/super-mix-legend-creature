extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]菊花镖"
	att.cd = 0.4
	att.spd = 0.8
	price = 300
	info = "从目标侧后方造成的伤害提高75%\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可以被科研装备吞噬[/color]"
func _connect():
	._connect()
	masCha.connect("onAtkChara",self,"onAtkChara")

func onAtkChara(atkInfo:AtkInfo):
	var cha = atkInfo.hitCha
	if masCha.team == cha.team:return
	if masCha.team == 1:
		if masCha.cell.x >= cha.cell.x:
			atkInfo.hurtVal *= 1.75
	if masCha.team == 2:
		if masCha.cell.x <= cha.cell.x:
			atkInfo.hurtVal *= 1.75
