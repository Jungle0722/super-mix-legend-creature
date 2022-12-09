extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「神秘」企业·黑化"   #角色的名称
	attCoe.atkRan = 4  #攻击距离
	attCoe.maxHp = 150   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 22	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 22  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）
	attAdd.cd += 1
	attAdd.spd += 1
	attAdd.dod += 0.7
	lv = 4             #等级的设置

	addSkill("每{cd}秒使用舰炮进行掩护射击，对当前目标造成[法强*3]的伤害，并使其四维降低30%", "舰炮掩护", "coverShoot", 5)
	addSkill("闪避提高70%，使用技能后：造成魔法伤害时附加同等真实伤害，同时有35%概率刷新CD", "LuckyE")
	addSkill("<先手><唯一><固化>每7秒让全体敌人攻速-30%，技能冷却速度-60%，双抗-60% 持续2秒", "灰色幽灵")
	addSkill("<先手>每{cd}秒赋予随机5名敌人<黑暗侵蚀>，持续5秒", "黑暗侵蚀", "darkErode", 5)
	addSkill("每{cd}秒弱驱散自身所有负面状态", "塞壬之力", "sr", 4)

	setGunAndArmor("大型","重型")
	isHead = true
	giftCha = "cex___al-qiye"

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="sr":
		sr()
	if id == "darkErode":
		darkErode()
	if id=="coverShoot":
		coverShoot()
	if sys.rndPer(35):
		var skill = getSkill(id)
		skill.nowTime += skill.cd/(1+att.cd)

func darkErode():
	var enemy = getAllChas(1)
	enemy.shuffle()
	for i in range(5):
		if i >= enemy.size():break
		enemy[i].addBuff(buffUtil.b_darkErode.new(5))

func _onBattleStart():
	._onBattleStart()
	if team == 2:
		addItem(sys.newItem(utils.getRandomItem("PHY")))
		addItem(sys.newItem(utils.getRandomItem("MGI")))
		addItem(sys.newItem(utils.getRandomItem("DEF")))
		cflag = 0
		cast()
		darkErode()

func cast():
	utils.createSkillTextEff("灰色幽灵", position)
	var chas = getAllChas(1)
	for i in chas:
		if not i.isDeath && not hasBuff("b_JDLY"):
			i.addBuff(b_JDLY.new(2))

var cflag = 0
func _upS():
	._upS()
	cflag += 1
	if cflag >= 7:
		cast()
		cflag = 0
		
class b_JDLY:
	extends Buff
	func _init(lv = 1):
		attInit()
		life = lv
		isNegetive = true
		att.spd = -0.3
		att.cd = -0.6
		att.mgiDefL = -0.6
		att.defL = -0.6
		id = "b_JDLY"

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.SKILL && atkInfo.hurtType == Chara.HurtType.MGI:
		azurHurtChara(atkInfo.hitCha, atkInfo.hurtVal, Chara.HurtType.REAL, Chara.AtkType.EFF, "LuckyE")

func coverShoot():
	if aiCha == null:
		var skill = getSkill("coverShoot")
		skill.nowTime += 3
		return
	var d:Eff = newEff("sk_feiDang",sprcPos)
	d._initFlyCha(aiCha)
	yield(d,"onReach")
	azurHurtChara(aiCha, att.mgiAtk*3, Chara.HurtType.MGI, Chara.AtkType.SKILL, "舰炮掩护")
	if aiCha.hasBuff("b_qiye") == null:
		aiCha.addBuff(b_qiye.new(5))

class b_qiye:
	extends Buff
	func _init(lv = 1):
		attInit()
		life = lv
		isNegetive = true
		att.mgiDefL = -0.3
		att.defL = -0.3
		att.atkL = -0.3
		att.mgiAtkL = -0.3
		id = "b_qiye"	