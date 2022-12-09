extends "../azurline_ctrl/fighter.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	attCoe.maxHp += 2
	chaName = "「战斗机」海毒牙"   #角色的名称
	addSkillTxt("每次突进后赋予当前目标4层<虚弱><漏水>")
	
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "tujin":
		aiCha.addBuff(buffUtil.b_weak.new(4))
		buffUtil.addLouShui(aiCha, self, 4)