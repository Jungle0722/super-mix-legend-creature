extends "../cazurlineF_2/cazurlineF_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「辅助」女灶神"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 2
	attCoe.mgiDef += 2
	attCoe.atkRan = 5
	lv = 3             #等级的设置
	evos = ["cazurlineF_2_3_1"]
	addSkill("所有友军(含召唤物)的承疗提高40%", "白鹰损管")

	autoGetSkill()
	setCamp("白鹰")
	ename = "zaoshen"

func _upS():
	._upS()
	for i in getAllChas(2):
		if i.hasBuff("b_vestal") == null:
			i.addBuff(b_vestal.new())

class b_vestal:
	extends Buff
	var buffName = "白鹰损管"
	var dispel = 2
	func _init():
		attInit()
		id = "b_vestal"
		att.reHp = 0.4
			