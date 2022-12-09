extends "../cazurlineE_6_1/cazurlineE_6_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」可畏·改"   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	addSkill("机库容量+10，自身舰载机阵亡时，立即刷新舰载机冷却时间", "补充支援")
	summLimit = 14
	addSkillTxt("[color=#C0C0C0][现代化改造]-机关禁止还将额外附带1秒眩晕(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func _onCharaDel(cha):
	._onCharaDel(cha)
	if summedCha.has(cha):
		var skill = getSkill("castPlane")
		skill.nowTime += skill.cd/(1+att.cd)