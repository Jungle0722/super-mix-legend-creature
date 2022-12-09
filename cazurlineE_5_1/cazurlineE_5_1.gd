extends "../cazurlineE_5/cazurlineE_5.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」翔鹤"   #角色的名称
	attCoe.maxHp += 2
	lv = 3             #等级的设置
	evos = ["cazurlineE_5_1_1"]
	addSkill("战斗开始时，若我方场上存在瑞鹤，法强提高500%", "五航战的荣耀")

	autoGetSkill()

func _onBattleStart():
	._onBattleStart()
	for i in getAllChas(2):
		if i.chaName.find("瑞鹤") > -1:
			addBuff(buffUtil.b_mgiAtkL.new(50))
			break
