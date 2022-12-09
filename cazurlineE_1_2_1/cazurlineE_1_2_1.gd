extends "../cazurlineE_1_2/cazurlineE_1_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」光辉·幼"   #角色的名称
	lv = 4             #等级的设置
	addSkill("每{cd}秒给1名生命值最低的友军提供[重点支援](双抗提升150，受到普攻回复施法者最大生命值3%的血量，持续4秒)", "重点支援", "zdzy", 6)

	addSkillTxt("[color=#C0C0C0][现代化改造]-装甲空母回血翻倍(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="zdzy":
		zdzy()

func zdzy():
	var chas = getAllChas(2)
	chas.sort_custom(self,"sortByHp")
	for i in chas:
		if not i.hasBuff("b_zdzy") and i.id != self.id:
			i.addBuff(utils.buffs.b_zdzy.new(att.maxHp*0.03))
			break
func upgrade():
	p3 = 0.1
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

