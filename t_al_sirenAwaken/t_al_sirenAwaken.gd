extends Talent
var siren = globalData.infoDs["g_azurlineSiren"]
func init():
	name = "塞壬觉醒"

func _connect():
	siren.sirenAwaken = true
	sys.newBaseMsg("提示", "塞壬觉醒天赋已激活，95层后，我方非塞壬角色无法造成伤害！")

func get_info():
	return "挑战券获得速度、我方塞壬成长速度提高135%\n我方塞壬20级将会觉醒\n[color=#DC143C]95层后，我方非塞壬角色无法造成伤害[/color]\n[color=#DC143C]此天赋不需要升级，仅限碧蓝航线使用"
