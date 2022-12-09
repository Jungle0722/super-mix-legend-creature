extends Talent
var azurCtrl = globalData.infoDs["g_azurline"]
func init():
	name = "μ兵装计划"

func _connect():
	azurCtrl.miuProject = 3

func get_info():
	return "我方μ兵装舰娘计算羁绊人数时，人数+3\n[color=#DC143C]此天赋不需要升级，仅限碧蓝航线使用"
