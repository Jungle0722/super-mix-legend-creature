extends "../azurline_ctrl/CAS.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轰炸机」九九式舰爆"   #角色的名称
	addSkillTxt("普攻附带6层<流血>并获得2层<急速>")
	
func _onNormalAtk(cha):
	._onNormalAtk(cha)
	if cha != null && not cha.isDeath:
		cha.addBuff(buffUtil.b_liuXue_r.new(6))
		addBuff(buffUtil.b_jiSu_r.new(2))

