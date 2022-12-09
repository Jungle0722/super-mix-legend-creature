extends Talent

var buffUtil = globalData.infoDs["g_azurlineBuffs"]
func init():
	name = "先进火控"
func _connect():
	sys.main.connect("onBattleStart",self,"run5")
	sys.main.connect("onCharaNewChara", self, "onCharaNewChara")

func onCharaNewChara(cha):
	if cha.team == 1:
		cha.addBuff(b_advancedFire.new())	

func run5():
	for i in sys.main.btChas:
		if i.team == 1:
			i.addBuff(b_advancedFire.new())

func get_info():
	return "我方所有角色(含召唤物)造成普攻伤害时，15%概率再次造成同等数值的普攻真实伤害(可套娃触发)\n[color=#DC143C]此天赋不需要升级，所有MOD通用"

class b_advancedFire extends Buff:
	var dispel = 2
	var buffName = "先进火控"
	func _init():
		attInit()
		id = "b_advancedFire"
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL && sys.rndPer(15) and count < 2:
			count += 1
			atkInfo.atkCha.azurHurtChara(atkInfo.hitCha, atkInfo.hurtVal, Chara.HurtType.REAL, Chara.AtkType.NORMAL, "先进火控")
	var count = 0
	func _upS():
		count = 0

