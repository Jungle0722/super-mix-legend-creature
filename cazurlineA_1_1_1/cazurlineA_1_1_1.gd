extends "../cazurlineA_1_1/cazurlineA_1_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」埃尔德里奇·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 1
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("<先手>每{cd}秒，随机使4名敌方单位陷入[沉睡]，持续5秒", "昏睡红茶", "sleepyTea", 5)
	addSkillTxt("[color=#C0C0C0][现代化改造]-昏睡红茶作用人数+1，沉睡被攻击打断时，该次攻击伤害提高200%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setCamp("白鹰")
var p4 = 4
var baseId = ""
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "sleepyTea":
		sleepyTea()

func sleepyTea():
	var chas = getAllChas(1)
	chas.shuffle()
	for i in range(p4):
		if i >= chas.size():break
		if chas[i].hasBuff("b_sleep"):continue
		chas[i].addBuff(b_sleep.new(5))

func _onBattleStart():
	._onBattleStart()
	sleepyTea()

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	p3 = 3
	p4 = 5

#沉睡
class b_sleep:
	extends Buff
	var buffName = "沉睡"
	var upgraded = false
	var utils = globalData.infoDs["g_azurlineUtils"]
	var eff2
	func _init(lv = 1, upgraded = false):
		attInit()
		id = "b_sleep"
		life = lv
		isNegetive=true
		self.upgraded = upgraded
	func _connect():
		._connect()
		masCha.aiOn = false
		masCha.connect("onHurt", self, "onHurt")
		eff2 = sys.newEff("animEff", masCha.position)
		eff2.setImgs(masCha.direc + "eff/sleep", 6, true)
		eff2.scale *= 0.8
		eff2.normalSpr.position=Vector2(0, -10)
	var num = 0
	func _upS():
		num += 1
	func onHurt(atkInfo:AtkInfo):
		if num <= 1:return
		if upgraded:
			atkInfo.hurtVal *= 3
		life = 0
		isDel = true
	func _del():
		._del()
		masCha.aiOn = true
		if is_instance_valid(eff2):
			eff2.queue_free()
	func _process(delta):
		if masCha != null && is_instance_valid(eff2):
			eff2.position = masCha.position