extends "../cazurlineF_1/cazurlineF_1.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「辅助」U47"   #角色的名称
	lv = 3             #等级的设置
	evos = ["cazurlineF_1_1_1"]
	addSkill("<唯一>提高我方潜艇舰娘40%血量、四维", "狼群战术")
	autoGetSkill()
	setCamp("铁血")

func _onBattleStart():
	._onBattleStart()
	for i in getAllChas(2):
		if utils.isSubMarine(i) and i.hasBuff("b_F11") == null:
			i.addBuff(b_F11.new())

class b_F11:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_F11"	
		att.maxHp = 0.4
		att.defL = 0.4
		att.mgiDefL = 0.4
		att.atkL = 0.4
		att.mgiAtkL = 0.4