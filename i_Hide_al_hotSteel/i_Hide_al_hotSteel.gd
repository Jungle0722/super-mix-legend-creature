extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]结晶化热强钢"
	info = "护甲值可以额外减免技能伤害，最多抵消80%伤害\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可被科研装备吞噬[/color]"
	price = 300
	att.def = 128
	att.mgiDef = 128
	
func _connect():
	._connect()
	masCha.connect("onHurt",self,"onHurt")

func onHurt(atkInfo):
	if atkInfo.atkType == Chara.AtkType.SKILL:
		var diff = atkInfo.hurtVal * 0.8 - masCha.att.def
		if diff > 0:
			atkInfo.hurtVal = diff
		else:
			atkInfo.hurtVal *= 0.2