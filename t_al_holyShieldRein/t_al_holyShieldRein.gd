extends Talent
var azurCtrl = globalData.infoDs["g_azurline"]
func init():
	name = "圣盾硬化"

func _connect():
	azurCtrl.holyShieldRein = true

func get_info():
	return "我方角色获得的圣盾，可以抵消技能伤害\n[color=#DC143C]此天赋不需要升级，仅限碧蓝航线使用"
