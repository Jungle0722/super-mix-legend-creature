extends "../cazurlineD_1/cazurlineD_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」长门"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	canCopy = false
	evos = ["cex___al-nagato2"]
	addSkill("<唯一>增加全体友军(含召唤物)：暴击15%，冷却15%，对重樱舰娘加成翻倍", "重樱舰队旗舰")

	autoGetSkill()
	supportSpecEvo = 2
	setCamp("重樱")

func _upS():
	._upS()
	for i in getAllChas(2):
		if not i.hasBuff("b_nagato"):
			if i.get("camp") == "重樱":
				i.addBuff(b_nagato.new(true))	
			else:
				i.addBuff(b_nagato.new(false))

class b_nagato:
	extends Buff
	var buffName = "重樱舰队旗舰"
	var dispel = 2
	func _init(flag = false):
		attInit()
		id = "b_nagato"
		if not flag:
			att.cri=0.15
			att.cd=0.15
		else:
			att.cri=0.3
			att.cd=0.3