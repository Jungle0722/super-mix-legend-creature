extends "../cazurlineE/cazurlineE.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」光荣"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 1
	attCoe.mgiDef += 1
	lv = 2             #等级的设置
	evos = ["cazurlineE_6_1", "cazurlineE_6_2"]
	addSkill("召唤舰载机时，使所有敌人获得4层<流血>", "机关禁止")
	setCamp("皇家")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="castPlane":
		for i in getAllChas(1):
			i.addBuff(buffUtil.b_liuXue_r.new(4))
			if upgraded:
				i.addBuff(buffUtil.b_xuanYun.new(1))
