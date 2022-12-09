extends "../cazurlineD_1/cazurlineD_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」土佐"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cazurlineD_1_3_1"]
	addSkill("每秒提高10%攻速，上限1000%", "速射")
	ename = "tuzuo"
	autoGetSkill()
	setCamp("重樱")

func _onBattleStart():
	._onBattleStart()
	addBuff(b_tuzuo.new())

class b_tuzuo:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_tuzuo"
	func _upS():
		if att.spd < 10:
			att.spd += 0.1