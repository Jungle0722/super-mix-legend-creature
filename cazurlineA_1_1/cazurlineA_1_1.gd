extends "../cazurlineA_1/cazurlineA_1.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「驱逐」埃尔德里奇"   #角色的名称
	attCoe.mgiAtk += 1 #魔法攻击（每点代表13.7）
	attCoe.maxHp += 1 #魔法攻击（每点代表13.7）
	lv = 3             #等级的设置
	evos = ["cazurlineA_1_1_1"]
	addSkill("<唯一>施放技能时使所有友军获得[彩虹](闪避+50%)，持续2秒", "彩虹计划")
	autoGetSkill()
	setCamp("白鹰")
var p3 = 2
func _castCdSkill(id):
	._castCdSkill(id)
	for i in getAllChas(2):
		if not i.hasBuff("b_caiHong"):
			i.addBuff(buffUtil.b_caiHong.new(p3))
