extends "../azurline_ctrl/BaseResearchItem.gd"
func init():
	.init()
	name = "[color=#DC143C][传说]三联装203MM主炮Mk15"
	att.atk = 120
	att.spd = 1
	info = "造成普攻伤害时有5%概率使敌人眩晕2秒\n普攻额外造成目标最大生命值15%的物理伤害"
var p1 = 5
var p2 = 0.15

func _connect():
	._connect()
	if masCha == null:return
	masCha.connect("onAtkChara",self,"run")
func run(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.NORMAL and atkInfo.hitCha.team != atkInfo.atkCha.team:
		masCha.azurHurtChara(atkInfo.hitCha, atkInfo.hitCha.att.maxHp*p2, Chara.HurtType.PHY, Chara.AtkType.EFF, "三联装203MM主炮Mk15")
		if sys.rndPer(p1):
			atkInfo.hitCha.addBuff(utils.buffs.b_xuanYun.new(2))