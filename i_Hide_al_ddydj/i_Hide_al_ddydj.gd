extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]电动扬弹机"
	info = "本回合内:\n每次普攻提高自身2%技能伤害(上限200%)\n每次施放技能提高自身20%普攻伤害(上限200%)\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效不能被科研装备吞噬[/color]"
	price = 300
	att.atk = 100
	att.mgiAtk = 100
	att.cri = 0.3
	att.criR = 0.3

func _connect():
	._connect()
	masCha.connect("onAtkChara", self, "onAtkChara")
	masCha.connect("onCastCdSkill", self, "onCastCdSkill")
	sys.main.connect("onBattleStart", self, "start")

func onAtkChara(atkInfo):
	if atkInfo.hurtType == Chara.HurtType.PHY and atkInfo.atkType == Chara.AtkType.NORMAL:
		if p1 < 2:p1 += 0.02
		atkInfo.factor += p2
	if atkInfo.atkType == Chara.AtkType.SKILL:
		atkInfo.factor += p1

func onCastCdSkill(id):
	if p2 < 3:p2 += 0.2

#技能伤害增益
var p1 = 0
#普攻伤害增益
var p2 = 0
func start():
	p1 = 0
	p2 = 0
	