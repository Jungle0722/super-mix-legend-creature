extends "../cazurlineF_1/cazurlineF_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「辅助」U81"   #角色的名称
	attCoe.mgiAtk += 1 #魔法攻击（每点代表13.7）
	lv = 3             #等级的设置
	evos = ["cazurlineF_1_3_1"]
	addSkill("我方潜艇舰娘造成的技能伤害提高50%", "集体狩猎")
	ename = "u81"
	autoGetSkill()
	setCamp("铁血")

func _onBattleStart():
	._onBattleStart()
	for i in getAllChas(2):
		if utils.isSubMarine(i):
			castBuff(i, b_F13.new())

class b_F13:
	extends Buff
	var buffName = "集体狩猎"
	var dispel = 2
	func _init():
		attInit()
		id = "b_F13"	
	func _connect():
		masCha.connect("onAtkChara",self,"run")
		if casCha.upgraded:
			att.mgiSuck += 1
	func run(atkInfo):
		if atkInfo.atkType == Chara.AtkType.SKILL:
			atkInfo.factor += 0.5
		if casCha.isAwaken and atkInfo.skill == "潜射鱼雷":
			atkInfo.factor += 2