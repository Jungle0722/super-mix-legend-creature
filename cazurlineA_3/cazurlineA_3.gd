extends "../cazurlineA/cazurlineA.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」吹雪"   #角色的名称
	attCoe.mgiAtk += 1  #魔法攻击（每点代表13.7）
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 2             #等级的设置
	evos = ["cazurlineA_3_1","cazurlineA_3_2"]
	addSkill("战斗开始时，使所有友军提高15%法强，对重樱舰娘加成翻倍", "特型领舰")
	setCamp("重樱")

func _onBattleStart():
	._onBattleStart()
	var ally=getAllChas(2)
	for i in ally:
		if i.get("camp") == "重樱":
			i.addBuff(b_moGong.new(3))
		else:
			i.addBuff(b_moGong.new(1.5))

class b_moGong:
	extends Buff
	var buffName = "特型领舰"
	func _init(num = 1):
		attInit()
		id = "b_moGong"	
		att.mgiAtkL = 0.1 * num

