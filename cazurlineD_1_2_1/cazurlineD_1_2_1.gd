extends "../cazurlineD_1_2/cazurlineD_1_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」骏河·花嫁"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("友方单位获得负面效果时，自身获得3层<狂怒><急速>", "不灭之盾")
	addSkillTxt("[color=#C0C0C0][现代化改造]-普攻时也有3%的几率召唤敌人为我方作战(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""
func _onBattleStart():
	._onBattleStart()		
	for i in getAllChas(2):
		i.addBuff(b_junHe.new(self))

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func _onNormalAtk(cha):
	._onNormalAtk(cha)
	if upgraded and sys.rndPer(3) and not atkInfo.hitCha.isSumm and atkInfo.hitCha.get("type") != "siren" and atkInfo.hitCha.get("type") != "BOSS":
		summChara(atkInfo.hitCha.id, true)

class b_junHe:
	extends Buff
	var dispel = 2
	var cha
	var buffUtil = globalData.infoDs["g_azurlineBuffs"]
	func _init(cha):
		attInit()
		id = "b_junHe"
		self.cha = cha
	func _connect():
		masCha.connect("onAddBuff",self,"onAddBuff")
	func onAddBuff(buff):
		if buff.isNegetive:
			cha.addBuff(buffUtil.b_kuangNu_r.new(3))
			cha.addBuff(buffUtil.b_jiSu_r.new(3))
