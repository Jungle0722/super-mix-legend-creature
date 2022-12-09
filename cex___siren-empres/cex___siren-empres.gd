extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「高级塞壬」仲裁者·恩普雷斯·III"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atkRan = 5  #攻击距离
	attCoe.maxHp = 220   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 20	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 20  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）
	attAdd.spd += 0.5
	attAdd.atkR += 0.5
	attAdd.penL += 0.3

	addSkill("开局随机获得3件装备，每{cd}秒召唤一名随机塞壬头目，并使其继承自身装备", "援军", "yj", 10)
	addSkill("受到普攻后，对周围2格内的敌人发动一次普攻", "抗拒")
	addSkill("每{cd}秒，将一名随机敌方单位吸引到自己周围，并使其眩晕5秒", "选召", "choosen", 7)
	addSkill("友军受到暴击时，进行裁决：使该次伤害无效或对攻击者造成等额伤害", "仲裁")
	addSkill("每{cd}秒弱驱散自身所有负面效果", "塞壬", "sr", 4)
	isHead = true

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="choosen":
		choosen()
	if id=="yj":
		yj()
	if id=="sr":
		sr()

func choosen():
	var cha = utils.getRndEnemy(self)
	for i in aroundCells:
		if matCha(cell+i) == null and cha.setCell(cell+i):
			cha.addBuff(buffUtil.b_xuanYun.new(5))
			break

func _onBattleStart():
	._onBattleStart()
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("DEF")))
	if difficult.difficult > 3:
		for i in items:
			if i.get("upgraded") != null:
				i.upgrade()
			else:
				difficult.itemUpgrade(i)
		learnRndSkill()

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		if difficult.difficult < 7:
			for i in getAroundChas(cell, false):
				.normalAtkChara(i)
		else:
			for i in getCellChas(cell, 2, 1):
				.normalAtkChara(i)

func yj():
	if difficult.difficult == 7:
		summChara(sys.rndListItem(gSiren.leaders)%[3], false)

	var cha = summChara(sys.rndListItem(utils.lv4), true)
	if sys.rndPer(50) and cha.has_method("upgrade") or difficult.difficult > 5:
		cha.upgrade()
		cha.upgraded = true
	if difficult.difficult > 1:
		summChara(sys.rndListItem(gSiren.leaders)%[2], false)

var index = 2
func _upS():
	._upS()
	index += 1
	if index >= 2:
		index = 0
		for i in getAllChas(2):
			if i.hasBuff("b_empres") == null:
				i.addBuff(b_empres.new(self))

class b_empres:
	extends Buff
	var dispel = 2
	var cha
	func _init(cha):
		attInit()
		id = "b_empres"
		self.cha = cha
	func _connect():
		masCha.connect("onHurt", self, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.isCri and atkInfo.atkCha.team != masCha.team:
			if sys.rndPer(50):
				atkInfo.hurtVal = 0
			else:
				cha.azurHurtChara(atkInfo.atkCha, min(atkInfo.atkCha.att.maxHp * 0.1, atkInfo.hurtVal), Chara.HurtType.REAL, Chara.AtkType.EFF, "仲裁")