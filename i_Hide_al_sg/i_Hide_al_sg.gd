extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]SG雷达"
	att.atk = 100
	att.atkRan = 5
	price = 300
	info = "雷达锁定当前目标，使其额外承受40%的伤害\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可以被科研装备吞噬[/color]"
func _connect():
	._connect()
	masCha.connect("onAtkChara",self,"run")

func run(atkInfo):
	if atkInfo.atkType == Chara.AtkType.NORMAL && not atkInfo.hitCha.hasBuff("b_SG") and atkInfo.hitCha.team != atkInfo.atkCha.team:
		atkInfo.hitCha.addBuff(b_SG.new(-0.4))
	
class b_SG:
	extends Buff
	var buffName = "SG雷达"
	func _init(num = -0.15):
		attInit()
		id = "b_SG"	
		isNegetive = true
		att.defR = num

