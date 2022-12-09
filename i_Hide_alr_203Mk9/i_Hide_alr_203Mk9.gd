extends "../azurline_ctrl/BaseResearchItem.gd"
func init():
	.init()
	name = "[color=#DC143C][传说]试作型三联203mm主炮Mk9"
	att.atkL = 0.2
	att.mgiAtkL = 0.2
	att.spd = 0.3
	info = "本场战斗内造成普攻伤害时会吸收该单位8%的四维属性为己用，每个角色只能被吸一次"

func _connect():
	._connect()
	if masCha == null:return
	masCha.connect("onAtkChara",self,"onAtkChara")
	sys.main.connect("onBattleEnd",self,"onBattleEnd")

var p2 = 0.08
var suckCha = []
func onAtkChara(atkInfo):
	if atkInfo.atkType == Chara.AtkType.NORMAL && not suckCha.has(atkInfo.hitCha) and not atkInfo.hitCha.isSumm:
		var cha = atkInfo.hitCha
		suckCha.append(cha)
		cha.addBuff(utils.buffs.b_wx_sub.new(-p2))
		var buff = masCha.hasBuff("b_gx_wuXun")
		if buff == null:
			masCha.addBuff(b_gx_wuXun.new(cha))
		else:
			buff.att.atk += cha.att.atk*p2
			buff.att.mgiAtk += cha.att.mgiAtk*p2
			buff.att.def += cha.att.def*p2
			buff.att.mgiDef += cha.att.mgiDef*p2

func onBattleEnd():
	suckCha = []

class b_gx_wuXun:
	extends Buff
	var buffName = "武勋"
	var dispel = 2
	func _init(cha):
		attInit()
		id = "b_gx_wuXun"	
		att.atk += cha.att.atk*0.08
		att.mgiAtk += cha.att.mgiAtk*0.08
		att.def += cha.att.def*0.08
		att.mgiDef += cha.att.mgiDef*0.08