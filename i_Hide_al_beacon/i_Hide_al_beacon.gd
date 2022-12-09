extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]归航信标"
	att.mgiAtk = 150
	att.cd = 0.3
	price = 300
	info = "机库容量+5\n若佩戴者是舰载机(通过航母继承)，每次使用技能，均降低召唤者所有技能冷却1秒\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效无法被科研装备吞噬[/color]"
func _connect():
	._connect()
	masCha.connect("onCastCdSkill",self,"onCastCdSkill")
	sys.main.connect("onBattleStart",self,"start")

func onCastCdSkill(id):
	if masCha.isSumm and masCha.get("type") == "plane" and masCha.get("summoner") != null:
		for i in masCha.summoner.skills:
			if i.cd - i.nowTime > 1.5:
				i.nowTime += 1

func start():
	if masCha != null and masCha.get("summoner") != null and masCha.get("type") == "plane":
		masCha.summoner.addBuff(b_al_beacon.new())

class b_al_beacon:
	extends Buff
	func _init():
		attInit()
		id = "b_al_beacon"	
	func _connect():
		masCha.summLimit += 5
	func _del():
		._del()
		masCha.summLimit -= 5