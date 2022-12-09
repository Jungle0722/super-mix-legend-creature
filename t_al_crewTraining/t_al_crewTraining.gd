extends Talent

var ctrl = globalData.infoDs["g_azurline"]
func init():
	name = "机组进阶训练"
func _connect():
	ctrl.crewTraining = true

func get_info():
	return "航母机组等级上限+10，10级后可以继承航母的随机技能\n[color=#DC143C]此天赋不需要升级，仅限碧蓝航线使用"

