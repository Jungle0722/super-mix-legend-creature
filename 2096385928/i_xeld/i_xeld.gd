extends Item

func init():
	name = "邪恶镰刀"
	type = config.EQUITYPE_EQUI
	attInit()
	att.mgiAtk = 100
	info = "战斗开始时使敌方攻击力和魔法强度之和最高的单位无害化3秒"

func _connect():
	sys.main.connect("onBattleStart",self,"StartBattle")

func StartBattle():
	var enemyChas = masCha.getAllChas(1)
	enemyChas.sort_custom(self,"SortByAtt")
	var eff:Eff = masCha.newEff("atk_gongJian",masCha.sprcPos)
	eff._initFlyCha(enemyChas[0])
	yield(eff,"onReach")
	enemyChas[0].addBuff(Dt_Harmless.new(1))

func SortByAtt(a,b):
	if (a.att.atk + a.att.mgiAtk) > (b.att.mgiAtk + b.att.atk):
		return true
	return false

class Dt_Harmless extends Buff:
	func _init(lv=1):
		attInit()
		effId = "p_shaoZhuo"
		life = 3
		isNegetive=true
		id = "Dt_Harmless"
	func _connect():
		connect("onSetCha",self,"_onSetCha")
	func _onSetCha():
		masCha.aiOn = false
	func _del():
		masCha.aiOn = true