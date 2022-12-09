extends "../cazurlineE_5_1/cazurlineE_5_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」翔鹤·花嫁"   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	addSkill("<先手>每{cd}秒对距离最远的两个敌人造成[法强*3]({damage})的伤害，并延长其技能冷却时间2秒", "珊瑚海阴云", "sk_xianghe", 6)

	addSkillTxt("[color=#C0C0C0][现代化改造]-鹤之加护减伤效果+10%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="sk_xianghe":
		sk_xianghe()

func sk_xianghe():
	var chas = getAllChas(1)
	chas.sort_custom(self, "sortByDistanceDesc")
	var arr = []
	while arr.size() < 2 and not chas.empty():
		arr.append(chas.pop_front())

	for i in arr:
		azurHurtChara(i, min(i.att.maxHp*1.2, att.mgiAtk*3), Chara.HurtType.MGI, Chara.AtkType.SKILL, "珊瑚海阴云")
		for j in i.skills:
			j.nowTime -= 2

var baseId = ""

func _onBattleStart():
	._onBattleStart()
	sk_xianghe()

func upgrade():
	p2 = 3.5
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")