extends Talent

var utils = globalData.infoDs["g_azurlineUtils"]
func init():
	name = "心智回收"
func _connect():
	sys.main.connect("onBattleStart",self,"onBattleStart")

func onBattleStart():
	for i in sys.main.btChas:
		if i.team == 1:
			i.addBuff(b_al_deathPt.new())

class b_al_deathPt:
	extends Buff
	var dispel = 2
	var azurCtrl = globalData.infoDs["g_azurline"]
	func _init():
		attInit()
		id = "b_al_deathPt"	
	func _connect():
		masCha.connect("onDeath",self,"_onDeath")
	func _onDeath(atkInfo):
		azurCtrl.plusPt(4)
		isDel = true

func get_info():
	return "我方[非召唤]舰娘彻底阵亡后，获得4PT\n此天赋不需要升级，仅限碧蓝航线使用"

