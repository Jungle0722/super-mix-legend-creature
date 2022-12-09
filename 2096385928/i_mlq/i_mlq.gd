extends Item

func init():
	name = "魔龙枪"
	type = config.EQUITYPE_EQUI
	attInit()
	att.atk = 80
	att.spd = 0.3
	att.atkRan = 2
	info = "攻击远距离的敌人额外造成25%伤害"

func _connect():
	masCha.connect("onAtkChara",self,"AttackProcess")

func AttackProcess(atkInfo:AtkInfo):
	print(masCha.cellRan(atkInfo.hitCha.cell))
	if masCha.cellRan(atkInfo.hitCha.cell) > 2:
		atkInfo.hurtVal *= 1.25