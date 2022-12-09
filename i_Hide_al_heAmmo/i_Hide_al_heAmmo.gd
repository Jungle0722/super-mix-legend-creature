extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]燃烧弹"
	info = "造成技能伤害时，降低目标60%的承疗效果，持续4秒，该效果无法被驱散但对塞壬效果减半，无法叠加\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可以被科研装备吞噬[/color]"
	price = 300
	att.mgiAtk = 200
	att.cd = 0.35
	
func _connect():
	._connect()
	masCha.connect("onAtkChara",self,"run")

func run(atkInfo):
	if atkInfo.atkType == Chara.AtkType.SKILL and atkInfo.hitCha.hasBuff("b_heAmmo") == null:
		atkInfo.hitCha.addBuff(buffUtil.b_heAmmo.new())

