extends Talent
var azurCtrl = globalData.infoDs["g_azurline"]
func init():
	name = "医疗专精"

func _connect():
	azurCtrl.healHpL = 0.45

func get_info():
	return "我方角色的治疗效果提高45%\n[color=#DC143C]此天赋不需要升级，仅限碧蓝航线使用"
