extends "../cazurlineD_5/cazurlineD_5.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」英王乔治五世"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1
	lv = 3             #等级的设置
	evos = ["cazurlineD_5_1_1"]
	addSkill("本回合所有被连接成员每秒提高15点双攻，上限400", "日不落余晖")

	autoGetSkill()
	setCamp("皇家")
var p3 = 15
func _upS():
	._upS()
	for i in connChas:
		if i.isDeath:continue
		var buff = i.hasBuff("b_royalFleet2")
		if buff == null:
			i.addBuff(b_royalFleet2.new())
		elif buff.att.atk < 400:
			buff.att.atk += p3
			buff.att.mgiAtk += p3

class b_royalFleet2:
	extends Buff
	var buffName = "日不落余晖"
	var dispel = 2
	func _init():
		attInit()
		id = "b_royalFleet2"	
		att.atk = 15
		att.mgiAtk = 15
	
