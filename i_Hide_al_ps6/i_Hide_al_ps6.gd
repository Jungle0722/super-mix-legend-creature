extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[特殊]PlayStation6 Pro"
	info = "能激发舰娘的潜力，但也会使其颓废\n使佩戴者造成的伤害提高200%，但每回合会损失10点双攻（对召唤物无效）"
	price = 300
	att.atk = 120
	att.mgiAtk = 120

func _connect():
	sys.main.connect("onBattleStart", self, "onBattleStart")

func onBattleStart():
	if masCha != null and masCha.has_method("updateTmpAtt"):
		masCha.updateTmpAtt("atk", -10)
		masCha.updateTmpAtt("mgiAtk", -10)
		masCha.addBuff(b_al_ps6.new())

class b_al_ps6:
	extends Buff
	var dispel = 2
	func _init(lv = 1):
		attInit()
		id = "b_al_ps6"
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		atkInfo.factor += 2