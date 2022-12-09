extends "../cazurlineE_4/cazurlineE_4.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」奥古斯特"   #角色的名称
	attCoe.maxHp += 2
	lv = 3             #等级的设置
	evos = ["cazurlineE_4_3_1"]
	addSkill("每{cd}秒赋予我方所有舰载机3层<圣盾><振奋>", "精密筹划", "jingmiCH", 8)
	ename = "aogusite"
	autoGetSkill()
	setGunAndArmor("小型","轻型")
	setCamp("铁血")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="精密筹划":
		jingmiCH()

func jingmiCH():
	for i in getAllChas(2):
		if i.isSumm and i.get("type") == "plane":
			i.addBuff(buffUtil.b_zhenFen.new(3))
			buffUtil.addShengDun(i, 3)
			if upgraded:
				buffUtil.addHuoLi(i, self, 3)