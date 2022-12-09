extends Talent
var azurCtrl = globalData.infoDs["g_azurline"]
func init():
	name = "团结一心"

func _connect():
	azurCtrl.addiPop = 20
	sys.main.upPop()

func get_info():
	return "立刻提高1点人口上限\n此天赋不需要升级，所有MOD通用"

