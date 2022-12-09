extends Talent
var utils = globalData.infoDs["g_azurlineUtils"]
func init():
	name = "强化药剂"
func _connect():
	sys.main.connect("onBattleEnd",self,"onBattleEnd")

func onBattleEnd():
	var rnd = min(sys.main.player.lv + 2, 15)
	var rngnum = sys.rndRan(1, 100)
	if rngnum <= rnd:
		sys.main.player.addItem(sys.newItem(sys.rndListItem(utils.consts.medis)))
	elif rngnum <= rnd*1.25:
		sys.main.player.addItem(sys.newItem(sys.rndListItem(utils.consts.rareMedis)))

func get_info():
	return "回合结束时，有一定概率随机获得一瓶药剂，用于强化舰娘属性\n几率随玩家等级提高而提高，有极低几率获得神秘药剂\n[color=#DC143C]此天赋不需要升级"

