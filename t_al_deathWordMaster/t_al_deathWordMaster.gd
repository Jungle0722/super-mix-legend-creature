extends Talent
var azurCtrl = globalData.infoDs["g_azurline"]
func init():
	name = "亡语专精"

func _connect():
	sys.main.connect("onBattleStart",self,"onBattleStart")

func onBattleStart():
	for i in sys.main.btChas:
		if i.team == 1 and i.has_method("deathWord"):
			i.addBuff(b_deathWordMaster.new())

class b_deathWordMaster:
	extends Buff
	var buffName = "亡语专精"
	var dispel = 2
	func _init():
		attInit()
		id = "b_deathWordMaster"	
	var index = 0
	func _upS():
		index += 1
		if index >= 8 and not masCha.isDeath:
			index = 0
			masCha.deathWord()

func get_info():
	return "战斗开始之后每8秒，触发我方所有角色的亡语效果\n[color=#DC143C]此天赋不需要升级，仅限碧蓝航线使用"
