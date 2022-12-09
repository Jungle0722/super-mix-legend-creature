extends Item

func init():
	name = "洞察烟斗"
	type = config.EQUITYPE_EQUI
	attInit()
	att.mgiDef = 60
	att.def = 30
	att.maxHp = 100
	info = "战斗开始时给所有友军套上能抵挡250点魔法伤害的护盾"

func _connect():
	sys.main.connect("onBattleStart",self,"StartBattle")

func StartBattle():
	var AllyChas = masCha.getAllChas(2)
	for i in AllyChas:
		i.addBuff(Dt_Sheild.new())

class Dt_Sheild extends Buff:
	var SheildVal = 250
	func _init(lv=1):
		attInit()
		effId = "p_diYu"
		life = 2
		isNegetive=false
		id = "Dt_Sheild"
	func _connect():
		masCha.connect("onHurt",self,"Hurt")
	func Hurt(atkInfo:AtkInfo):
		if SheildVal > atkInfo.hurtVal && atkInfo.hurtType == Chara.HurtType.MGI:
			SheildVal -= atkInfo.hurtVal
			atkInfo.hurtVal = 0
		elif SheildVal == atkInfo.hurtVal && atkInfo.hurtType == Chara.HurtType.MGI:
			atkInfo.hurtVal = 0
			isDel = true
		elif SheildVal < atkInfo.hurtVal && atkInfo.hurtType == Chara.HurtType.MGI:
			atkInfo.hurtVal -= (atkInfo.hurtVal - SheildVal)
			isDel = true
	func _upS():
		life += 1