extends Talent
var azurCtrl = globalData.infoDs["g_azurline"]
func init():
	name = "圣盾缓冲"

func _connect():
	azurCtrl.holyShield = true

func get_info():
	return "我方角色的圣盾层数被消耗时，获得3层<活力><狂怒><魔力>\n[color=#DC143C]此天赋不需要升级，仅限碧蓝航线使用"
