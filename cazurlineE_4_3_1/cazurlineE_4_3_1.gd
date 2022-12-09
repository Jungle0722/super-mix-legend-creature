extends "../cazurlineE_4_3/cazurlineE_4_3.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」奥古斯特·改"   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	addSkill("舰载机会双倍继承航母的装备，无视装备槽限制", "超重起飞")

	addSkillTxt("[color=#C0C0C0][现代化改造]-精密筹划额外赋予3层<活力>(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func castPlane():
	var cha = .castPlane()
	if cha != null:
		cha.maxItem *= 2
		for i in items:
			var item = sys.newItem(i.id)
			if i.get("upgraded") == true && i.has_method("upgrade"):
				item.upgrade()
			cha.addItem(item)