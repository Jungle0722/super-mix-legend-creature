extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]灭火器"
	info = "免疫<烧蚀><灼烧>\n受到魔法伤害降低50%\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效无法被科研装备吞噬[/color]"
	price = 300
	att.maxHp = 500
	att.def = 80
	att.mgiDef = 80
	att.dod = 0.2

var includes = ["b_shaoShi", "b_shaoZhuo_r", "b_shaoZhuo"]
func _connect():
	._connect()
	masCha.connect("onAddBuff",self,"onAddBuff")
	masCha.connect("onHurt",self,"onHurt")

func onAddBuff(buff:Buff):
	if includes.has(buff.id):
		buff.isDel = true
func onHurt(atkInfo):
	if atkInfo.hurtType == Chara.HurtType.MGI:
		atkInfo.hurtVal *= 0.5