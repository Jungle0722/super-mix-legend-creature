extends Talent

var buffUtil = globalData.infoDs["g_azurlineBuffs"]
func init():
	name = "航空战术"
func _connect():
	sys.main.connect("onCharaNewChara", self, "onCharaNewChara")
	sys.main.connect("onBattleStart",self,"run7")

func onCharaNewChara(cha):
	if cha.team == 1:
		cha.addBuff(b_airTactics.new())

func run7():
	for i in sys.main.btChas:
		if i.team == 1:
			i.addBuff(buffUtil.b_antiSumm.new(5))

func get_info():
	return "舰载机(含召唤物)获得20%的伤害与20%减伤加成，同时提高50%我方舰队对召唤物造成的伤害\n[color=#DC143C]此天赋不需要升级，所有MOD通用"

class b_airTactics extends Buff:
	var buffName = "航空战术"
	func _init():
		attInit()
		att.atkR=0.2
		att.defR=0.2
		id = "b_airTactics"

