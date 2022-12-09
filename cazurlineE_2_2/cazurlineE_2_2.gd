extends "../cazurlineE_2/cazurlineE_2.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「航母」埃塞克斯"   #角色的名称
	attCoe.maxHp += 3   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	lv = 3             #等级的设置
	evos = ["cazurlineE_2_2_1"]
	addSkill("舰载机受到更高的加成系数", "天与海的观测者")

	autoGetSkill()
	setCamp("白鹰")
		
func castPlane():
	var summ = summPlane(true)
	if summ != null && not summ.isDeath and team == 1:
		var ap = float(att.mgiAtk + att.atk)
		summ.attAdd.maxHp += ap*lv/5.0
		summ.plusHp(ap*lv/5.0)
		summ.attAdd.def = ap*lv/4.0
		summ.attAdd.mgiDef = ap*lv/4.0
		summ.attAdd.atk = ap*lv/4.0
		summ.attAdd.mgiAtk = ap*lv/4.0
		summ.attAdd.pen = ap*lv/10.0
		summ.attAdd.mgiPen = ap*lv/10.0
		summ.upAtt()