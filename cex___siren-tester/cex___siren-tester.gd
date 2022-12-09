extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「高级塞壬」测试者α型"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atkRan = 5  #攻击距离
	attCoe.maxHp = 130   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 15	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 15  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）
	addSkill("开局随机获得3件装备，每{cd}秒召唤一名随机3级舰娘，并使其获得10层[狂怒][急速]", "援军", "yj", 10)

	addSkill("每{cd}秒使敌方物攻最高者对其自身普攻3次", "攻击测试", "atkTest2", 8)
	addSkill("每{cd}秒对当前目标周围2格的敌人造成[目标双防*3]的真实伤害", "防御测试", "defTest", 8)
	addSkill("每次施放技能，恢复自身2%血量并对自身周围2格的敌人造成等额的魔法伤害", "施法测试")

	addSkill("每{cd}秒弱驱散自身所有负面状态", "塞壬", "sr", 4)

	isHead = true
	giftCha = "cex___al-tester"
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="atkTest2":
		atkTest2()
	if id=="defTest":
		defTest()
	if id=="yj":
		yj()
	if id=="sr":
		sr()

	healCha(self, att.maxHp*0.02)
	for i in getCellChas(cell, 2, 1):
		azurHurtChara(i, att.maxHp*0.02, Chara.HurtType.MGI, Chara.AtkType.SKILL, "施法测试")

func atkTest2():
	var chas = getAllChas(1)
	chas.sort_custom(self, "sort2")
	for i in range(3):
		chas[0].normalAtkChara(chas[0])

func defTest():
	var chas = getCellChas(aiCha.cell, 2, 1)
	for i in chas:
		azurHurtChara(i, aiCha.att.def + aiCha.att.mgiDef, Chara.HurtType.REAL, Chara.AtkType.EFF, "防御测试")
		
func yj():
	var cha = summChara(sys.rndListItem(utils.lv3))
	if cha != null:
		cha.addBuff(buffUtil.b_kuangNu_r.new(10))
		cha.addBuff(buffUtil.b_jiSu_r.new(10))

func sort2(a,b):
	if a.get("type") == "BOSS" && b.get("type") != "BOSS":
		return false
	return a.att.atk > b.att.atk

func _onBattleStart():
	._onBattleStart()
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("MGI")))
	addItem(sys.newItem(utils.getRandomItem("DEF")))