extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "航空副油箱"
	att.maxHp = 200
	att.mgiAtk = 50
	att.atk = 50
	att.def = 50
	att.mgiDef = 50
	info = "提高自身舰载机100%血量\n[color=#DC143C]同时装备三件时可升级[/color]"
func _connect():
	if masCha.get("tag") == "azurline":
		masCha.connect("summChara",self,"summChara")
	utils.itemUpgrade(self)

func summChara(cha):
	var num = cha.att.maxHp*p
	cha.attInfo.maxHp += num
	cha.upAtt()
	cha.plusHp(num)
	
var p = 1
var upgraded = false
func upgrade():
	name = "[color=#FFFF00]航空副油箱·改"
	info = "提高自身舰载机200%血量"
	att.maxHp = 400 * relic.equipBonus
	att.mgiAtk = 100 * relic.equipBonus
	att.atk = 100 * relic.equipBonus
	att.def = 100 * relic.equipBonus
	att.mgiDef = 100 * relic.equipBonus
	p = 2

