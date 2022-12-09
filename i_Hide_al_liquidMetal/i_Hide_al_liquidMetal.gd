extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[稀有]拟态金属"
	flag = true
	rollAtt()
	info = "所有属性随机，被装备之前，每回合会变化一次属性"
	if sys.main != null && not sys.main.is_connected("onBattleReady",self,"rollAtt"):
		sys.main.connect("onBattleReady", self, "rollAtt")

var flag = true
func _connect():
	flag = false
	if masCha.team != 1:
		att.mgiAtk = 100
		att.atk = 100
	info = "属性已固定"

func setAtt(name, minValue, maxValue, chance, isFloat=false):
	if sys.rndPer(chance):
		if not isFloat:
			att.set(name, sys.rndRan(minValue, maxValue))
		else:
			att.set(name, sys.rndRan(minValue, maxValue)/100.0)
		yield(sys.get_tree().create_timer(0.03), "timeout")
		
func clearAtt():
	attInit()

func rollAtt():
	if not flag:return
	clearAtt()
	if sys.rndPer(30):
		att.maxHp = sys.rndRan(100, 1000)
	else:
		att.maxHp = 0

	#1：ad，2：ap，3：t
	var type = 3
	var rnd = sys.rndRan(1, 100)
	if rnd <= 40:
		type = 1
	elif rnd <= 80:
		type = 2

	if type == 1:
		setAtt("atk", 30, 200, 80)
		setAtt("spd", 20, 80, 40, true)
		setAtt("suck", 20, 80, 25, true)
		setAtt("pen", 20, 100, 20)
		setAtt("penL", 20, 40, 20, true)
		setAtt("cri", 20, 40, 30, true)
		setAtt("criR", 20, 40, 30, true)
		setAtt("cd", 20, 40, 15, true)
		setAtt("dod", 20, 40, 15, true)
	elif type == 2:
		setAtt("mgiAtk", 30, 200, 100)
		setAtt("spd", 20, 100, 20, true)
		setAtt("mgiSuck", 20, 80, 25, true)
		setAtt("mgiPen", 20, 100, 25)
		setAtt("mgiPenL", 20, 40, 20, true)
		setAtt("cri", 20, 40, 15, true)
		setAtt("criR", 20, 40, 15, true)
		setAtt("cd", 20, 40, 30, true)
	else:
		setAtt("maxHp", 100, 800, 100)
		setAtt("def", 10, 200, 80)
		setAtt("mgiDef", 10, 200, 80)
		setAtt("dod", 10, 50, 50, true)

	setAtt("atkRan", 1, 3, 15)
# #name, min, max, chance, isFloat
# func rndAtt(name, min, max, chance, isFloat=true):
# 	pass
# if sys.rndPer(chance):
# 	if not isFloat:
# 		att.set(name, sys.rndRan(min, max))
# 	else:
# 		att.set(name, sys.rndRan(min, max)/100.0)
# else:
# 	att.set(name, 0)

	
