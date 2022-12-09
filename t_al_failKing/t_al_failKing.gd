extends Talent
var azurCtrl = globalData.infoDs["g_azurline"]
var buffUtil = globalData.infoDs["g_azurlineBuffs"]
var utils = globalData.infoDs["g_azurlineUtils"]
func init():
	name = "破败王者"
func _connect():
	yield(sys.get_tree().create_timer(0.5), "timeout")
	if not azurCtrl.failKing:
		azurCtrl.failKing = true
		azurCtrl.failProtect += 2

func get_info():
	return "我方非BOSS关卡战败时，拥有2次免战败的机会\n[color=#DC143C]此天赋不需要升级"
