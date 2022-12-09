extends Item

func init():
	name = "回音战刃"
	type = config.EQUITYPE_EQUI
	attInit()
	att.atk = 60
	info = "每3次攻击额外造成一次攻击，并且在2秒内减缓目标30%攻击速度"

var Nums = 0

func _connect():
	masCha.connect("onAtkChara",self,"DoubleAtk")

func DoubleAtk(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		if Nums < 3:
			Nums += 1
		else:
			masCha.normalAtkChara(atkInfo.hitCha)
			atkInfo.hitCha.addBuff(Dt_SladeAtkSpdDefuse.new())
			Nums = 0

class Dt_SladeAtkSpdDefuse extends Buff:
	func _init(lv=1):
		attInit()
		att.spd -= 0.3
		effId = "p_jieShuang"
		life = 2
		id = "Dt_SladeAtkSpdDefuse"
		isNegetive=true