extends Talent
var azurCtrl = globalData.infoDs["g_azurline"]
func init():
	name = "全明星阵容"

func _connect():
	azurCtrl.allStar = true

func get_info():
	return "当全部十位μ兵装舰娘上场时，极大强化她们的兵装解放技能\n此天赋不需要升级，所有MOD通用"

