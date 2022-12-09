extends Talent
var utils = globalData.infoDs["g_azurlineUtils"]
func init():
	name = "军备补给"
func _connect():
	sys.main.connect("onBattleEnd",self,"onBattleEnd")

func onBattleEnd():
	var rnd = min(sys.main.player.lv + 4, 15)
	if sys.rndPer(rnd):
		utils.rollItem(1, 0, "军备补给奖励")

func get_info():
	return "回合结束时，有一定概率获得一件随机装备\n几率随玩家等级提高而提高，有极低几率获得稀有装备\n[color=#DC143C]此天赋不需要升级，所有MOD通用"

