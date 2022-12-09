extends Talent

var azurCtrl = globalData.infoDs["g_azurline"]
func init():
	name = "指挥官进阶训练"
func _connect():
	azurCtrl.commanderTraining = true

func get_info():
	return "指挥官重置技能便宜85%，进阶速度提高35%，每回合获得的属性提高50%\n[color=#DC143C]此天赋不需要升级"

