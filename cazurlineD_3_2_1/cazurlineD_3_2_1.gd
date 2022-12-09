extends "../cazurlineD_3_2/cazurlineD_3_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」南达科他·改"   #角色的名称
	attCoe.maxHp += 3
	lv = 4             #等级的设置
	addSkill("<亡语>死后立即满血复活，并获得<涅槃>，每场战斗触发一次", "快速抢修")

	addSkillTxt("[color=#C0C0C0][现代化改造]-最强之盾回血系数+20%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	xfSkillFlag = false
	setCamp("白鹰")

var baseId = ""
var isSurvive = false
func _onDeath(atkInfo):
	._onDeath(atkInfo)
	if not isSurvive and isDeath:
		isSurvive = true
		isDeath = false
		healCha(self, att.maxHp)
		addBuff(b_NiePan.new())
		updateTmpAtt("maxHp", 300)
		
func deathWord():
	.deathWord()
	updateTmpAtt("maxHp", 40)

func _onBattleStart():
	._onBattleStart()
	isSurvive = false

class b_NiePan:
	extends Buff
	var buffName = "涅槃"
	func _init():
		attInit()
		id = "b_NiePan"
		att.atk = 200
		att.mgiAtk = 200
		att.def = 200
		att.mgiDef = 200

func upgrade():
	p3 = 0.6
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")