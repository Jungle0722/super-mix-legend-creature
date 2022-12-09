extends "../azurline_ctrl/carrier.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「航母」凤翔"   #角色的名称
	attCoe.atkRan = 5#攻击距离
	attCoe.maxHp = 1#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 1     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 3  #魔法攻击（每点代表13.7）
	attCoe.def = 1     #物理防御（每点代表15）
	attCoe.mgiDef = 1#魔法防御（每点代表16.6）
	lv = 1             #等级的设置
	atkEff = "atk_dang" #攻击时的特效
	evos = ["cazurlineE_1","cazurlineE_2","cazurlineE_3","cazurlineE_4","cazurlineE_5","cazurlineE_6"]
	addSkill("<先手>每{cd}秒起飞一架受自身双攻加成的<舰载机>(←点击可查看说明)", "舰载机", "castPlane", 12)

	setGunAndArmor("小型","轻型")
	setCamp("重樱")
	if team == 2 and sys.main.guankaMsg.lvStep > 45:
		var p = difficult.factor
		if difficult.step > 80:
			p *= 2
		if sys.rndPer(p):
			masCha.crewEquip = utils.getRndPlane()
			if sys.rndPer(p):
				masCha.crewEquip = utils.getRndPlane(true)
	
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="castPlane":
		self.castPlane()

func castPlane():
	var summ = summPlane()
	if lv == 1:return summ
	if summ != null and not summ.isDeath and team == 1:
		var ap = float(att.mgiAtk + att.atk)
		summ.attAdd.maxHp += (ap/6.0)*lv
		summ.plusHp((ap/6.0)*lv)
		summ.attAdd.def = (ap/7.0)*lv
		summ.attAdd.mgiDef = (ap/7.0)*lv
		summ.attAdd.atk = (ap/5.5)*lv
		summ.attAdd.mgiAtk = (ap/5.5)*lv
		summ.upAtt()
	return summ


func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "支援空母":
		return att.mgiAtk * 2
	elif name == "舰队支援":
		return att.maxHp * 0.15
	elif name == "装甲空母":
		return att.maxHp * 0.04
	elif name == "先手必胜":
		return att.mgiAtk * 3
	elif name == "恶作剧":
		return att.mgiAtk * 3
	elif name == "空域控制":
		return att.mgiAtk * 0.5
	elif name == "珊瑚海阴云":
		return att.mgiAtk * 3
	elif name == "迅击铁翼":
		return att.def * 4
	elif name == "领航之箭":
		return (att.atk + att.mgiAtk + att.def + att.mgiDef)*0.8
	elif name == "樱绽凤华":
		return att.mgiAtk * 2

		