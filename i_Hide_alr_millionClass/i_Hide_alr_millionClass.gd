extends "../azurline_ctrl/BaseResearchItem.gd"
func init():
	.init()
	name = "[color=#DC143C][传说]兆级加农炮"
	att.atkL = 0.4
	att.mgiAtkL = 0.4
	att.penL = 0.4
	att.mgiPenL = 0.4
	att.cri = 0.4
	info = "对超重型装甲的敌人额外造成40%的伤害"

func _connect():
	._connect()
	if masCha == null:return
	masCha.connect("onAtkChara",self,"onAtkChara")

func onAtkChara(atkInfo):
	if atkInfo.hitCha.get("armorType") == "超重型":
		atkInfo.factor += 0.4

