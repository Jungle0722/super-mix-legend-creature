extends "../cazurlineD_6_1/cazurlineD_6_1.gd"
func _info():
	pass
var baseId = ""
func _extInit():
	._extInit()
	chaName = "「战列」加斯科涅·改"   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 1
	addSkill("每{cd}秒使全体敌人获得4秒<感知抑制>(射程-1，造成伤害时有30%概率落空)", "感知抑制", "perceptualInhibition", 8)

	addSkillTxt("[color=#C0C0C0][现代化改造]-感知抑制持续时间+2秒(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="perceptualInhibition":
		perceptualInhibition()

func perceptualInhibition():
	for i in getAllChas(1):
		i.addBuff(b_jskn.new(p4))

class b_jskn:
	extends Buff
	var buffName = "感知抑制"
	func _init(lv = 1):
		attInit()
		id = "b_jskn"
		att.atkRan = -1
		life = lv
	func _connect():
		masCha.connect("onAtkChara",self,"run")
	func run(atkInfo):
		if not atkInfo.isMiss and sys.rndPer(30):
			atkInfo.isMiss = true
			atkInfo.hurtVal = 0
var p4 = 4
func upgrade():
	p4 = 6
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")