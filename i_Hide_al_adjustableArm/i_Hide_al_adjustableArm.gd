extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]可塑性机械臂"
	info = "造成法术技能伤害时，临时偷取目标2点四维属性，同一个目标最多偷取100次\n若目标属性小于0，则无法触发属性偷取\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效不能被科研装备吞噬"
	price = 300
	att.cd = 0.2
	att.spd = 0.3

func _connect():
	._connect()
	masCha.connect("onAtkInfo", self, "onAtkInfo")
	sys.main.connect("onBattleStart", self, "start")

func onAtkInfo(atkInfo):
	if atkInfo.hurtType == Chara.HurtType.MGI and atkInfo.atkType == Chara.AtkType.SKILL:
		var bf = atkInfo.hitCha.hasBuff("b_adjustableArm")
		if bf == null:
			bf = atkInfo.hitCha.addBuff(b_adjustableArm.new(masCha))
		bf.inCr()
		
func start():
	if masCha != null:
		masCha.addBuff(b_adjustableArm2.new())

class b_adjustableArm:
	extends Buff
	var dispel = 2
	var cha
	func _init(cha):
		attInit()
		id = "b_adjustableArm"
		self.cha = cha
	func inCr():
		var bf = cha.hasBuff("b_adjustableArm2")
		if bf == null:return
		if masCha.att.atk > 0 and att.atk > - 200:
			att.atk -= 2
			bf.att.atk += 2
		if masCha.att.mgiAtk > 0 and att.mgiAtk > - 200:
			att.mgiAtk -= 2
			bf.att.mgiAtk += 2
		if masCha.att.def > 0 and att.def > - 200:
			att.def -= 2
			bf.att.def += 2
		if masCha.att.mgiDef > 0 and att.mgiDef > - 200:
			att.mgiDef -= 2
			bf.att.mgiDef += 2

class b_adjustableArm2:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_adjustableArm2"
		att.atk = 0
		att.mgiAtk = 0
		att.def = 0
		att.mgiDef = 0
			