extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]高性能舵机"
	att.mgiAtk = 100
	att.def = 80
	att.mgiDef = 80
	price = 300
	info = "每次使用技能，获得5层<振奋>\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可以被科研装备吞噬[/color]"

func _connect():
	._connect()
	masCha.connect("onCastCdSkill", self, "onCastCdSkill")

func onCastCdSkill(id):
	masCha.addBuff(utils.buffs.b_zhenFen.new(5))
