extends Talent

var buffUtil = globalData.infoDs["g_azurlineBuffs"]
func init():
	name = "弹性防御"
func _connect():
	sys.main.connect("onBattleStart",self,"run5")

func run5():
	for i in sys.main.btChas:
		if i.team == 1:
			i.addBuff(b_elasticDefend.new())

func get_info():
	return "战斗开始时赋予我方所有角色减伤，其中最后一列的角色获得60%减伤，每往前一列减少10%，减伤数值每秒降低2%，为0时消失\n[color=#DC143C]此天赋不需要升级，所有MOD通用"

class b_elasticDefend extends Buff:
	var num = 0.6
	var dispel = 2
	var buffName = "弹性防御"
	func _init():
		attInit()
		id = "b_damageControl"
	func _connect():
		masCha.connect("onHurt",self,"_onHurt")
		num = (6 - masCha.cell.x) * 0.1
	func _upS():
		num -= 0.02
		if num <= 0:
			isDel = true
	func _onHurt(atkInfo:AtkInfo):
		if num > 0 and atkInfo.hurtVal > 5:
			atkInfo.hurtVal *= (1-num)
