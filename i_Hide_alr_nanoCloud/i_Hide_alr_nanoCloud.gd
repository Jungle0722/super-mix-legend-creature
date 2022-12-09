extends "../azurline_ctrl/BaseResearchItem.gd"
func init():
	.init()
	name = "[color=#DC143C][传说]纳米机械云"
	att.atk = 200
	att.mgiAtk = 200
	att.maxHp = 1000
	att.cd = 0.3
	info = "治疗效果提高100%\n对其他角色产生治疗效果时，为其附加1层圣盾\n该特效对同一个目标拥有1秒的内置冷却，召唤物携带无法触发"

func _connect():
	._connect()
	sys.main.connect("onBattleStart",self,"start")
	if not masCha.isSumm:
		masCha.connect("healCha", self, "healCha")
var arrs = []
func healCha(cha):
	if not arrs.has(cha):
		buffUtil.addShengDun(cha, 1)
		arrs.append(cha)

func _upS():
	if masCha == null or masCha.isDeath:return
	arrs.clear()

func start():
	arrs.clear()
	if masCha != null:
		masCha.addBuff(b_al_nanoCloud.new())

class b_al_nanoCloud:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_al_nanoCloud"	
	func _connect():
		masCha.healHpL += 1
	func _del():
		._del()
		masCha.healHpL -= 1