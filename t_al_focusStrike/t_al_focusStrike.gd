extends Talent

var buffUtil = globalData.infoDs["g_azurlineBuffs"]
func init():
	name = "重点打击"
func _connect():
	sys.main.connect("onBattleStart",self,"run5")
	sys.main.connect("onCharaNewChara", self, "onCharaNewChara")

func onCharaNewChara(cha):
	if cha.team == 1:
		cha.addBuff(b_focusStrike.new())	

func run5():
	for i in sys.main.btChas:
		if i.team == 1:
			i.addBuff(b_focusStrike.new())

func get_info():
	return "我方角色(含召唤物)提高18%暴击率\n[color=#DC143C]此天赋不需要升级，所有MOD通用"

class b_focusStrike extends Buff:
	var dispel = 2
	var buffName = "重点打击"
	func _init():
		attInit()
		id = "b_focusStrike"
		att.cri = 0.18
