extends Talent
var azurCtrl = globalData.infoDs["g_azurline"]
func init():
	name = "护盾专精"

func _connect():
	azurCtrl.shieldBonus = 0.40

func get_info():
	return "我方角色获得的护盾增加40%\n[color=#DC143C]此天赋不需要升级，仅限碧蓝航线使用"
