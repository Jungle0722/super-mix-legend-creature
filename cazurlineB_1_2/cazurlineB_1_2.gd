extends "../cazurlineB_1/cazurlineB_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」贝法"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	lv = 3             #等级的设置
	evos = ["cazurlineB_1_2_1"]
	addSkill("每{cd}秒向最靠前的3名友军位置投掷烟雾弹，使其闪避提升50%，造成伤害提升25%，持续5秒", "烟雾弹", "ywd", 5)
	autoGetSkill()
	setCamp("皇家")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="ywd":
		ywd()

func ywd():
	var chas = getAllChas(2)
	chas.sort_custom(self,"sortByFront")
	for i in range(3):
		if i >= chas.size():break
		var c = chas[i]
		createFlyEff(sprcPos, c, "sk_4_1_2")
		if c.hasBuff("b_bf_ywd") == null:
			c.addBuff(b_bf_ywd.new(5))

class b_bf_ywd:
	extends Buff
	var buffName = "烟雾弹"
	func _init(lv = 1):
		attInit()
		id = "b_bf_ywd"
		life = lv
		att.dod = 0.5
		att.atkR = 0.25