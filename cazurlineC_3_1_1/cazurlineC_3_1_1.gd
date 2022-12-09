extends "../cazurlineC_3_1/cazurlineC_3_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」欧根亲王·誓约"   #角色的名称
	attCoe.maxHp += 4   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	lv = 4             #等级的设置
	addSkill("将自身30%的护甲/魔抗转化为生命值，受到物理/魔法伤害时，若该伤害大于自身护甲/魔抗，\n则将其降低50%", "穿甲防护")
	addSkillTxt("[color=#C0C0C0][现代化改造]-不破之盾每秒回盾系数翻倍(未解锁)")
	addSkillTxt("[color=#C0C0C0]一次次面对俾斯麦被击沉而自己却无能为力，欧根亲王可能会觉醒...")	
	if upgraded:
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()

func awaken(msg = true):
	chaName = "「重巡」欧根亲王·觉醒"
	addSkill("<唯一>替我方俾斯麦承受所有伤害，并将该伤害完全反弹给攻击者", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "欧根亲王已经获得了心智觉醒！")
	isAwaken = true

var baseId = ""

func _onBattleStart():
	._onBattleStart()
	var num = (att.def + att.mgiDef) * 0.3
	attAdd.maxHp += num * 4
	healCha(self, num * 4)
	attAdd.def -= att.def * 0.3
	attAdd.mgiDef -= att.mgiDef * 0.3
	for i in getAllChas(2):
		if i.hasBuff("b_ougen") == null and i.chaName.find("俾斯麦") > -1:
			i.addBuff(b_ougen.new(self))

func _onBattleEnd():
	._onBattleEnd()
	attAdd.def = 0
	attAdd.mgiDef = 0
	attAdd.maxHp = 0

func _onHurt(atkInfo):
	var d = max(100, att.def)
	var md = max(100, att.mgiDef)
	if atkInfo.hurtType == Chara.HurtType.PHY && atkInfo.hurtVal > d:
		atkInfo.hurtVal *= 0.5
	elif atkInfo.hurtType == Chara.HurtType.MGI && atkInfo.hurtVal > md:
		atkInfo.hurtVal *= 0.5
	._onHurt(atkInfo)

func upgrade():
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	p3 = 0.1

class b_ougen:
	extends Buff
	var buffName = "心智觉醒·欧根亲王"
	var cha
	var dispel = 2
	func _init(cha):
		attInit()
		id = "b_ougen"	
		self.cha = cha
	func _connect():
		masCha.connect("onHurt",self,"onHurt")
		masCha.connect("onDeath",self,"onDeath")
	func onHurt(atkInfo):
		if cha.isDeath or atkInfo.hurtVal < 1 or not cha.isAwaken:return
		atkInfo.atkCha.azurHurtChara(cha, atkInfo.atkVal, atkInfo.hurtType, atkInfo.atkType, atkInfo.get("skill"))
		cha.azurHurtChara(atkInfo.atkCha, atkInfo.atkVal, atkInfo.hurtType, atkInfo.atkType, "心智觉醒")
		atkInfo.hurtVal = 1
	func onDeath(atkInfo):
		if cha.isAwaken:return
		cha.awakenProcess += 1
		if cha.awakenProcess >= 20:
			cha.awaken()
