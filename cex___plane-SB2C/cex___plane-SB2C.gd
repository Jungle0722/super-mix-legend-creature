extends "../azurline_ctrl/CAS.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轰炸机」SB2C地狱俯冲者"   #角色的名称
	addSkillTxt("普攻额外造成目标最大生命值10%的物理伤害")
	
func _onNormalAtk(cha):
	._onNormalAtk(cha)
	if not cha.isDeath:
		azurHurtChara(cha, min(60000, cha.att.maxHp)*0.1, Chara.HurtType.PHY,Chara.AtkType.EFF, "SB2C地狱俯冲者")