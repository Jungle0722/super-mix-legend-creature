extends Talent

var utils = globalData.infoDs["g_azurlineUtils"]
func init():
	name = "全勤工作"
func _connect():
	sys.main.connect("onBattleStart",self,"onBattleStart")

func onBattleStart():
	var gold = 0
	for i in utils.getReadyChas():
		if i.lv == 3:
			gold += 20
		elif i.lv == 4:
			gold += 60	
	sys.main.player.plusGold(min(240, gold))

func get_info():
	return "每回合，我方场下每个3级角色，产出20金币，每个4级角色，产出60金币(上限240)\n[color=#DC143C]此天赋不需要升级"

