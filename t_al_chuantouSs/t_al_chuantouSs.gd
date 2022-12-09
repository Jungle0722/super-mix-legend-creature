extends Talent

var buffUtil = globalData.infoDs["g_azurlineBuffs"]
func init():
	name = "穿透损伤"
func _connect():
	sys.main.connect("onBattleStart",self,"run5")
	sys.main.connect("onCharaNewChara", self, "onCharaNewChara")

func onCharaNewChara(cha):
	if cha.team == 1:
		cha.addBuff(b_chuantouSS.new())	

func run5():
	for i in sys.main.btChas:
		if i.team == 1:
			i.addBuff(b_chuantouSS.new())

func get_info():
	return "我方角色的魔法伤害，额外受到[法术穿透率 * 50%]的伤害加成，上限50%\n[color=#DC143C]此天赋不需要升级，所有MOD通用"

class b_chuantouSS extends Buff:
	var dispel = 2
	var buffName = "穿透损伤"
	func _init():
		attInit()
		id = "b_chuantouSS"
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.hurtType == Chara.HurtType.MGI and masCha.att.mgiPenL > 0:
			atkInfo.factor += min(0.5, masCha.att.mgiPenL * 0.6)
