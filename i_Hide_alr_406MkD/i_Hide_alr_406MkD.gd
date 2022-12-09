extends "../azurline_ctrl/BaseResearchItem.gd"
func init():
	.init()
	name = "[color=#DC143C][传说]试作型三联406MM主炮MkD"
	att.suck = 0.3
	att.spd = 0.3
	att.def = 150
	att.defL = 0.2
	att.maxHp = 1000
	info = "每2秒，弱驱散当前攻击目标所有增益效果\n战斗开始时，获得[自身护甲值100%]的攻击"
var p = 1

func _connect():
	._connect()
	sys.main.connect("onBattleStart",self,"start")

func start():
	masCha.addBuff(b_alr_406MkD2.new(masCha.att.def*p))

var index = 0
func _upS():
	if masCha.aiCha == null:return
	index += 1
	if index >= 2:
		index = 0
		for i in masCha.aiCha.buffs:
			if i.get("type") != config.EQUITYPE_EQUI && i.get("dispel") != 2 and i.get("dispel") != 3 and not i.isNegetive:
				i.isDel = true

class b_alr_406MkD2:
	extends Buff
	func _init(atk = 0):
		attInit()
		id = "b_alr_406MkD2"	
		att.atk = atk