extends "../cazurlineC_3/cazurlineC_3.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」希佩尔海军上将"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #物理防御（每点代表15）
	attCoe.def += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cazurlineC_3_2_1"]
	addSkill("战斗开始时，嘲讽全场敌人，并获得70%减伤，持续5秒", "诱敌深入")

	autoGetSkill()
	itemEvoCha2 = "cex___almiu-hipper"
	setCamp("铁血")
var p3 = 5
func _onBattleStart():
	._onBattleStart()
	if team == 1:
		var chas = getAllChas(1)
		for i in chas:
			i.addBuff(buffUtil.b_taunt.new(p3, self))
			i.aiCha = self
	else:
		addBuff(buffUtil.b_atkL.new(8))
		addBuff(buffUtil.b_reHp.new(8))
	addBuff(b_hipper.new(p3))

class b_hipper:
	extends Buff
	var buffName = "诱敌深入-减伤"
	var dispel = 2
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_hipper"
		att.defR = 0.7
		
