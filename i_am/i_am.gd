extends "../azurline_base_item/azurline_base_item.gd"

func init():
	.init()
	name = "黯灭"
	att.atk = 100
	info = "被攻击的单位减少35%护甲，持续3秒 "

func _connect():
	masCha.connect("onAtkChara",self,"Ready")

func Ready(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		utils.buffs.addAnMie(atkInfo.hitCha, 1)