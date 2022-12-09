extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
var allCell = []
func _extInit():
	._extInit()
	chaName = "「高级塞壬」织梦者"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atkRan = 5  #攻击距离
	attCoe.maxHp = 170   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 18	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 20  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）
	attAdd.spd += 1

	addSkill("开局随机获得3件装备，每{cd}秒召唤一名随机4级舰娘，并使其继承自身装备", "援军", "yj", 8)

	addSkill("每{cd}秒，诅咒所有敌人，造成[法强*2]的伤害，并附加3层<霜冻>", "编织噩梦", "bzem", 8)
	addSkill("战斗开始时，随机复制10名敌方单位（包括装备、技能），并使其获得4秒无敌", "梦境投影")
	addSkill("所有敌人技能冷却速度降低20%，每{cd}秒，延长所有敌人的技能4秒冷却时间", "梦想封印", "mxfy", 10)
	addSkill("受到的物理伤害降低50%，额外受到20%的魔法伤害", "虚无存在")

	addSkill("每{cd}秒弱驱散自身所有负面状态", "塞壬", "sr", 4)
	addCdSkill("mxfy",10)
	isHead = true
	giftCha = "cex___al-weaveDream"

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="mxfy":
		mxfy()
	if id=="bzem":
		bzem()
	if id=="yj":
		yj()
	if id=="sr":
		sr()

func mxfy():
	var chas = getAllChas(1)
	for i in chas:
		for j in i.skills:
			j.nowTime += 4

func bzem():
	var chas = getAllChas(1)
	for i in chas:
		azurHurtChara(i, min(i.att.maxHp*1.2, att.mgiAtk*2), Chara.HurtType.MGI, Chara.AtkType.SKILL, "编织噩梦")
		i.addBuff(buffUtil.b_freeze.new(3))
		
func yj():
	var cha = summChara(sys.rndListItem(utils.lv4), true)
	if sys.rndPer(50) and cha.has_method("upgrade"):
		cha.upgrade()
		cha.upgraded = true

func _onBattleStart():
	._onBattleStart()
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("MGI")))
	addItem(sys.newItem(utils.getRandomItem("DEF")))
	var chas = getAllChas(1)
	for i in chas:
		i.addBuff(buffUtil.b_cd.new(-2))
	var count = 0
	for i in chas:
		if count >= 10:break
		if i.get("type") == "siren":continue
		count += 1
		var cha = summChara(i.id)
		cha.addBuff(buffUtil.b_wudi.new(4))
		for j in i.items:
			cha.addItem(sys.newItem(j.id))
		if i.get("skillSlot") != null && cha.has_method("enemyGetSkill"):
			cha.enemyGetSkill(i.get("skillSlot"))

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.hurtType == Chara.HurtType.PHY:
		atkInfo.hurtVal *= 0.5
	if atkInfo.hurtType == Chara.HurtType.MGI:
		atkInfo.hurtVal *= 1.2	