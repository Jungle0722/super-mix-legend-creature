extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]九八式射击延迟装置"
	att.atk = 100
	att.mgiAtk = 100
	price = 300
	info = "延长技能冷却时间75%，提高自身技能伤害75%\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可被科研装备吞噬[/color]"

func _connect():
	._connect()
	utils.itemUpgrade(self)
	masCha.connect("onAtkChara",self,"onAtkChara")
	masCha.connect("onCastCdSkill",self,"onCastCdSkill")

func onCastCdSkill(id):
	var sk = masCha.getSkill(id)
	sk.nowTime -= sk.cd/(1 + masCha.att.cd) * 0.75 

func onAtkChara(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.SKILL:
		atkInfo.hurtVal *= 1.75
