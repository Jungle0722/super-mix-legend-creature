extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]开拓者奖章"
	info = "血量大于50%时，获得35%伤害提升\n血量低于50%时，获得35%伤害减免\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可以被科研装备吞噬[/color]"
	price = 300
	att.mgiAtk = 150
	att.atk = 150
	att.maxHp = 500
	att.dod = 0.2
	
func _connect():
	._connect()
	masCha.connect("onAtkChara",self,"onAtkChara")
	masCha.connect("onHurt",self,"onHurt")

func onAtkChara(atkInfo):
	if masCha.att.hp / masCha.att.maxHp >= 0.5:
		atkInfo.hurtVal *= 1.35

func onHurt(atkInfo):
	if masCha.att.hp / masCha.att.maxHp <= 0.5:
		atkInfo.hurtVal *= 0.65






