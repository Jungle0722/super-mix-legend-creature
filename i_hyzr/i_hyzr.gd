extends "../azurline_base_item/azurline_base_item.gd"

func init():
	.init()
	name = "回音战刃"
	att.atk = 60
	info = "每3次攻击额外造成一次攻击，并且在2秒内减缓目标30%攻击速度"

var hyzrNums = 0

func _connect():
	masCha.connect("onAtkChara",self,"DoubleAtk")

func DoubleAtk(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		if hyzrNums < 3:
			hyzrNums += 1
		else:
			masCha.normalAtkChara(atkInfo.hitCha)
			#atkInfo.hitCha.addBuff(Dt_SladeAtkSpdDefuse.new())
			hyzrNums = 0

