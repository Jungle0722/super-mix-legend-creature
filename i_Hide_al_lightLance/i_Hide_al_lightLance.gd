extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]光矛"
	info = "每5秒，对所有具有护盾的敌人造成[目标护盾值*200%]的魔法伤害\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可被科研装备吞噬[/color]"
	price = 300
	att.mgiAtk = 200
	att.cd = 0.3
	att.mgiSuck = 0.4
	
func _connect():
	._connect()
	sys.main.connect("onBattleEnd",self,"end")

var num = 0
func _upS():
	._upS()
	num += 1
	if num >= 5:
		for i in masCha.getAllChas(1):
			if i.get("shield") > 0:
				masCha.azurHurtChara(i, i.get("shield")*2, Chara.HurtType.MGI, Chara.AtkType.SKILL, "光矛")
		num = 0

func end():
	num = 0
