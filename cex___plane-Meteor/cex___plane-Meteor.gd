extends "../azurline_ctrl/TBF.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「鱼雷机」流星"   #角色的名称
	addSkillTxt("每5秒对目标周围一格的敌人造成[法强*3]的伤害")
	addCdSkill("sk", 5)

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "sk":
		for i in getCellChas(aiCha.cell, 1, 1):
			hurtChara(i, att.mgiAtk*3, Chara.HurtType.MGI, Chara.AtkType.SKILL)
			

