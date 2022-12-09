extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「高级塞壬」代行者·IX"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atkRan = 5  #攻击距离
	attCoe.maxHp = 210   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 21	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 19  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）
	attAdd.suck += 0.4
	attAdd.spd += 0.5
	addSkill("开局随机获得3件装备，每10秒召唤一名随机4级舰娘，并使其获得10层<振奋>", "援军", "yj", 10)
	addSkill("每7秒弱驱散自身所有负面效果", "塞壬", "sr", 7)

	addSkill("<固化>每10秒降低所有敌人10%的四维与血上限", "逆风")
	addSkill("免疫技能伤害", "绝缘")
	addSkill("每8秒强驱散当前目标身上的增益效果，并使其四维降低50%", "静电", "jingDian", 8)
	isHead = true
	giftCha = "cex___al-executer-c"

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="yj":
		yj()
	if id=="sr":
		sr()
	if id=="jingDian":
		jingDian()

func yj():
	var cha = summChara(sys.rndListItem(utils.lv4), true)
	cha.addBuff(buffUtil.b_zhenFen.new(10))

func jingDian():
	for j in aiCha.buffs:
		if not j.isNegetive && j.get("type") != config.EQUITYPE_EQUI:
			j.isDel = true
	aiCha.addBuff(b_executer_c2.new())

func _onBattleStart():
	._onBattleStart()
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("DEF")))
	addItem(sys.newItem(utils.getRandomItem("DEF")))
	for i in getAllChas(1):
		i.addBuff(b_executer_c.new())
			
func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkType == Chara.AtkType.SKILL:
		atkInfo.hurtVal = 0

class b_executer_c:
	extends Buff
	var buffName = "逆风"
	var dispel = 2
	func _init():
		attInit()
		id = "b_executer_c"
		isNegetive = true
		att.atkL = -0.1
		att.mgiAtkL = -0.1
		att.defL = -0.1
		att.mgiDefL = -0.1
		att.maxHpL = -0.1
	var index = 0
	func _upS():
		index += 1
		if index >= 10:
			index = 0
			if masCha.att.atk > 0:
				att.atkL -= 0.1
			if masCha.att.mgiAtk > 0:
				att.mgiAtkL -= 0.1
			if masCha.att.def > 0:
				att.defL -= 0.1
			if masCha.att.mgiDef > 0:
				att.mgiDefL -= 0.1
			if masCha.att.maxHp > 0:
				att.maxHpL -= 0.1

class b_executer_c2:
	extends Buff
	var buffName = "静电"
	var dispel = 2
	func _init():
		attInit()
		id = "b_executer_c"
		isNegetive = true
	func _connect():
		if masCha.att.atk > 0:
			att.atk -= masCha.att.atk * 0.4
		if masCha.att.mgiAtk > 0:
			att.mgiAtk -= masCha.att.mgiAtk * 0.4
		if masCha.att.def > 0:
			att.def -= masCha.att.def * 0.4
		if masCha.att.mgiDef > 0:
			att.mgiDef -= masCha.att.mgiDef * 0.4
		