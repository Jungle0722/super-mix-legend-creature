extends Item

func init():
	name = "天堂之戟"
	type = config.EQUITYPE_EQUI
	attInit()
	att.atk = 50
	att.maxHp = 200
	att.dod = 0.25
	info = "每第五次攻击使目标的攻击无效化2秒"
	
func _connect():
	masCha.connect("onAtkChara",self,"Invalidate")
	sys.main.connect("onBattleStart",self,"StartBattle")

var AttackNums = 0

func StartBattle():
	AttackNums = 0

func Invalidate(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.NORMAL && AttackNums == 5:
		atkInfo.hitCha.addBuff(Dt_InvalidateAttack.new())
		AttackNums = 0
	if atkInfo.atkType == Chara.AtkType.NORMAL && AttackNums < 5:
		AttackNums += 1

class Dt_InvalidateAttack:
	extends Buff
	func _init():
		attInit()
		effId = "p_shiMing"
		life = 2
		isNegetive=true
	func _connect():
		masCha.connect("onAtkChara",self,"AttackMiss")
	func AttackMiss(atkInfo:AtkInfo):
		if atkInfo.atkType == Obj.AtkType.NORMAL:
			atkInfo.isMiss = true
			atkInfo.atkType = Chara.AtkType.MISS