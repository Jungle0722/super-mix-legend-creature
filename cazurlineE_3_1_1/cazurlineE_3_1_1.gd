extends "../cazurlineE_3_1/cazurlineE_3_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」大凤·改"   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 2
	attCoe.def += 1
	attCoe.mgiDef += 1
	attCoe.mgiAtk += 1
	addSkill("<固化>每10秒使全体友军[无敌]2秒", "凤之守护")

	addSkillTxt("[color=#C0C0C0][现代化改造]-神风战机受自身大凤法强加成提高40%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setCamp("重樱")
var baseId = ""
var flag = 0
func _upS():
	._upS()
	flag += 1
	if flag >= 10:
		hzsh()
		flag = 0

func _onBattleEnd():
	._onBattleEnd()
	flag = 0

func hzsh():
	utils.createSkillTextEff("凤之守护", position)
	var chas = getAllChas(2)
	for i in chas:
		if not i.hasBuff("b_yzfh"):
			i.addBuff(utils.buffs.b_yzfh.new(2))

func upgrade():
	p3 = 0.0010
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")