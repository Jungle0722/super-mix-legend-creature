extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]点金手"
	info = "对血量低于[双攻*3]的敌人造成伤害时，将其秒杀，并获得[目标等级*4]的金币(内置冷却3秒)\n若携带者为召唤物，则无法触发\n累计获得：%d\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效无法被科研装备吞噬[/color]"%0
	price = 300
	att.atk = 120
	att.mgiAtk = 120
	
func _connect():
	._connect()
	if masCha.isSumm:return
	masCha.connect("onAtkChara",self,"onAtkChara")
	sys.main.connect("onBattleEnd",self,"end")

var num = 0
func onAtkChara(atkInfo):
	if atkInfo.hitCha.att.hp <= (masCha.att.atk + masCha.att.mgiAtk)*3 and index <= 0 and atkInfo.hitCha.team != masCha.team:
		index = 3
		masCha.increDmgNum(atkInfo.hitCha.att.hp, "点金手", atkInfo.hitCha)
		atkInfo.hitCha.forceHurtSelf(atkInfo.hitCha.att.maxHp)
		sys.main.player.plusGold(atkInfo.hitCha.lv*4)
		num += atkInfo.hitCha.lv*4
		atkInfo.hurtVal = 0

func end():
	info = "对血量低于[双攻*3]的敌人造成伤害时，将其秒杀，并获得[目标等级*4]的金币(内置冷却3秒)\n累计获得：%d"%num
	index = 0
var index = 0
func _upS():
	index -= 1