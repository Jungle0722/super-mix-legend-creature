extends "../azurline_ctrl/fighter.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战斗机」海大黄蜂"   #角色的名称
	attAdd.dod = 0.3
	attAdd.defR = 0.15
	lv = 4             #等级的设置
	addSkillTxt("每次突进后嘲讽周围2格的敌人，并获得50%减伤，持续3秒")
	addSkillTxt("每次受到非特效伤害，赋予攻击者3层<剧毒>")
	addSkillTxt("受到的暴击伤害降低50%")

var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "tujin":
		for cha in getCellChas(cell, 2, 1):
			cha.addBuff(buffUtil.b_taunt.new(6, self))
			cha.aiCha = self
		addBuff(buffUtil.b_hurtVal.new(0.5, 3))

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.isCri:
		atkInfo.hurtVal *= 0.5
	if atkInfo.atkType != Chara.AtkType.EFF and atkInfo.atkCha.team != team:
		buffUtil.addJuDu(atkInfo.atkCha, self, 3)