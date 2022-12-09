extends "../cazurlineE/cazurlineE.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」千岁"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 2             #等级的设置
	evos = ["cazurlineE_5_1", "cazurlineE_5_2"]
	addSkill("每次起飞舰载机时，赋予全体友军5秒<鹤之加护>(降低20%所受伤害，乘算)", "鹤之加护")

	setCamp("重樱")
var p2 = 2
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="castPlane":
		sk_qiansui()

func sk_qiansui():
	for i in getAllChas(2):
		addBuff(buffUtil.b_hurtVal.new(p2, 5))
