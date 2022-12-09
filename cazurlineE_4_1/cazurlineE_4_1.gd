extends "../cazurlineE_4/cazurlineE_4.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」无畏"   #角色的名称
	attCoe.maxHp += 2
	lv = 3             #等级的设置
	evos = ["cazurlineE_4_1_1"]
	addSkill("舰载机等级上限提高至20级，且经验获取速度翻倍", "王牌机组")

	autoGetSkill()
	setGunAndArmor("小型","轻型")
	summExpBonus = 2
	crewMaxLv = 20
	setCamp("白鹰")


