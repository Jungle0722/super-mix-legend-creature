extends "../azurline_ctrl/BaseResearchItem.gd"
func init():
	.init()
	name = "[color=#DC143C][传说]试作型三联234mm主炮"
	att.atk = 100
	att.penL = 0.2
	att.atkRan = 1
	att.cri = 0.2
	info = "击杀敌人时，随机永久提高少量的(攻击/冷却/吸血/攻速/爆伤)\n当前被攻击目标获得治疗时，窃取其中一半的治疗量"
var p = 3			
func _connect():
	._connect()
	if masCha == null:return
	masCha.connect("onKillChara",self,"onKillChara")
	masCha.connect("onAtkChara",self,"onAtkChara")
func onKillChara(atkInfo):
	var rndNum = sys.rndRan(1, 5)
	match rndNum:
		1:
			att.atk += p
		2:
			att.cd += 0.01
		3:
			att.suck += 0.01
		4:
			att.spd += 0.01
		5:
			att.criR += 0.01

func onAtkChara(atkInfo):
	if atkInfo.hitCha.hasBuff("b_alr_234") == null and atkInfo.hitCha.team != masCha.team:
		atkInfo.hitCha.addBuff(b_alr_234.new(masCha))

class b_alr_234:
	extends Buff
	var dispel = 2
	var cha
	func _init(cha):
		attInit()
		id = "b_alr_234"
		self.cha = cha
	func _connect():
		masCha.connect("onPlusHp", self, "onPlusHp")
	func onPlusHp(num):
		if int(num) > 1:
			masCha.forceHurtSelf(cha, num/2)
			cha.healCha(num/2)