extends "../azurline_ctrl/BaseResearchItem.gd"
func init():
	.init()
	name = "[color=#DC143C][传说]引力舞鞋"
	att.atkR = 0.3
	att.spd = 0.3
	att.cd = 0.3
	att.defL = 0.3
	att.mgiDefL = 0.3
	info = "[color=#DC143C]仅限μ兵装舰娘装备[/color]\n使该舰娘终极觉醒：兵装解放技能获得极大增强"

func _connect():
	._connect()
	if masCha == null:return
	if masCha.chaName.find("μ兵装") == -1:
		delFromCha()
		return