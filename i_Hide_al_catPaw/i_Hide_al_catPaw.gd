extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]治愈系猫爪"
	info = "治疗效果+100%\n佩戴者造成治疗时，使被治疗目标获得20%减伤，持续3秒(不可叠加，乘算)\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效不能被科研装备吞噬"
	price = 300
	att.mgiAtk = 100
	att.atk = 100
	
func _connect():
	._connect()
	if masCha.get("tag") != "azurline":
		delSelf()
		return
	sys.main.connect("onBattleStart",self,"start")
	masCha.connect("healCha", self, "healCha")

func start():
	if masCha != null:
		masCha.addBuff(b_al_catPaw.new())

func healCha(cha):
	if cha.hasBuff("b_al_catPaw2") == null:
		cha.addBuff(b_al_catPaw2.new(3))

class b_al_catPaw:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_al_catPaw"	
	func _connect():
		masCha.healHpL += 1
	func _del():
		._del()
		masCha.healHpL -= 1

class b_al_catPaw2:
	extends Buff
	var buffName = "猫爪·减伤"
	func _init(lv = 1):
		attInit()
		id = "b_al_catPaw2"
		life = lv
	func _connect():
		masCha.connect("onHurt",self,"run")
	func run(atkInfo):
		atkInfo.hurtVal *= 0.8