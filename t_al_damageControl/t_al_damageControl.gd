extends Talent

var buffUtil = globalData.infoDs["g_azurlineBuffs"]
func init():
	name = "氪金损管"
func _connect():
	sys.main.connect("onBattleStart",self,"run5")

func run5():
	for i in sys.main.btChas:
		if i.team == 1:
			i.addBuff(b_damageControl.new())

func get_info():
	return "一回合内，我方所有角色(除召唤物)都有免疫2次致命伤害的机会\n[color=#DC143C]此天赋不需要升级，所有MOD通用"

class b_damageControl extends Buff:
	var num = 2
	var dispel = 2
	func _init():
		attInit()
		id = "b_damageControl"
	func _connect():
		masCha.connect("onHurt",self,"_onHurt")
	func _onHurt(atkInfo:AtkInfo):
		if num > 0 and atkInfo.hurtVal > masCha.att.hp && not atkInfo.isMiss:
			atkInfo.hurtVal = 0
			num -= 1
		if num == 0:
			isDel = true
