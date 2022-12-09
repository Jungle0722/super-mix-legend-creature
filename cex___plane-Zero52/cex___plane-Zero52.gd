extends "../azurline_ctrl/fighter.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	attCoe.atk += 2
	chaName = "「战斗机」零战五二型"   #角色的名称
	addSkillTxt("每次突进后获得10层急速")
	
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "tujin":
		addBuff(buffUtil.b_jiSu_r.new(10))