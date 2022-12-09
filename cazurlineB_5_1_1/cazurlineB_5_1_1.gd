extends "../cazurlineB_5_1/cazurlineB_5_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」平海·改"   #角色的名称
	lv = 4             #等级的设置
	addSkill("<亡语>死亡时随机召唤一名继承自身装备的传奇舰娘", "壮志难酬")

	addSkillTxt("[color=#C0C0C0][现代化改造]-壮志难酬有30%概率额外召唤一次(未解锁)")
	setGunAndArmor("中型","中型")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""

func deathWord():
	.deathWord()
	if not isDeath and sys.rndPer(35):return
	summChara(sys.rndListItem(utils.lv4), true)
	if upgraded and sys.rndPer(30):
		summChara(sys.rndListItem(utils.lv4), true)

var p4 = 0
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	p4 = 1