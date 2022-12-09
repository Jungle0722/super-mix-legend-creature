extends "../cazurlineB_5_2/cazurlineB_5_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」肇和·改"   #角色的名称
	lv = 4             #等级的设置
	addSkill("死亡后召唤一名会攻击队友的特殊敌方单位：思念体，该单位会继承自身装备、属性、随机技能", "思念寄托")

	addSkillTxt("[color=#C0C0C0][现代化改造]-思念寄托获得<亡语>属性，思念体获得100%攻速加成(未解锁)")
	setGunAndArmor("中型","中型")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""

func deathWord():
	.deathWord()
	if not upgraded and not isDeath:return
	doSumm()
	if relic.deathWordBonus and team == 1:
		doSumm()

func doSumm():
	var cha = summEnemy("cex___altmp-B52", true)
	if cha == null:return
	cha.summoner = self
	cha.addBuff(buffUtil.b_vague.new(3))
	if upgraded:
		cha.upgrade()
	cha.fromJson(toJson(), false)

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")