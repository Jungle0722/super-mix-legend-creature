extends "../cazurlineE_4_2/cazurlineE_4_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」半人马·誓约"   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	addSkill("为周围3格的友军舰载机提供20%减伤，且每秒恢复[法强*1]({damage})的血量", "空域控制")

	addSkillTxt("[color=#C0C0C0][现代化改造]-空域控制作用于全体友军舰载机(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _upS():
	._upS()
	if not upgraded:
		var chas = getCellChas(cell, 3, 2)
		for i in chas:
			if not i.isSumm:continue
			if i.hasBuff("b_defR") == null:
				i.addBuff(buffUtil.b_defR.new(2, 8))
			healCha(i, att.mgiAtk*0.5)
	else:
		for i in getAllChas(2):
			if not i.isSumm:continue
			if i.hasBuff("b_defR") == null:
				i.addBuff(buffUtil.b_defR.new(2, 8))
			healCha(i, att.mgiAtk*0.5)

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")