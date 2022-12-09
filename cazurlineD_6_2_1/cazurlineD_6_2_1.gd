extends "../cazurlineD_6_2/cazurlineD_6_2.gd"
func _info():
	pass
var baseId = ""
func _extInit():
	._extInit()
	chaName = "「战列」苏维埃贝拉罗斯·改"   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 1
	addSkill("每{cd}秒赋予血量最低的友军8层<圣盾>", "战况把握", "situationGap", 8)

	addSkillTxt("[color=#C0C0C0][现代化改造]-被陨落冰耀击中后，若目标身上的霜冻大于18层，则对其造成[目标血上限*0.4]的真实伤害(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="situationGap":
		situationGap()

func situationGap():
	var cha = getFirstCha(2, "sortByHp")
	if cha == null:return
	buffUtil.addShengDun(cha, 8)

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")