extends "../azurline_ctrl/fighter.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	attCoe.maxHp += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	chaName = "「战斗机」F6F地狱猫"   #角色的名称
	addSkillTxt("每次突进后嘲讽目标并获得10层抵御、魔御")
	
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "tujin":
		aiCha.addBuff(buffUtil.b_taunt.new(6, self))
		aiCha.aiCha = self
		addBuff(buffUtil.b_diYu_r.new(10))
		addBuff(buffUtil.b_moYu_r.new(10))
