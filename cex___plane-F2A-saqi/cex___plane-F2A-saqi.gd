extends "../azurline_ctrl/fighter.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	attCoe.def += 1
	chaName = "「战斗机」F2A水牛·萨奇队"   #角色的名称
	lv = 4             #等级的设置
	addSkillTxt("每次突进后嘲讽附近1格的目标并获得50%减伤，持续3秒")
	
var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "tujin":
		for cha in getCellChas(cell, 1, 1):
			cha.addBuff(buffUtil.b_taunt.new(6, self))
			cha.aiCha = self
		addBuff(buffUtil.b_hurtVal.new(0.5, 3))	
