extends "../azurline_ctrl/CAS.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	attCoe.atk += 2
	attCoe.maxHp += 1
	chaName = "「轰炸机」彗星"   #角色的名称
	addSkillTxt("普攻附带5层随机负面效果")
	
func _onNormalAtk(cha):
	._onNormalAtk(cha)
	if cha != null && not cha.isDeath:
		buffUtil.addRndDebuff(self, cha, 5)