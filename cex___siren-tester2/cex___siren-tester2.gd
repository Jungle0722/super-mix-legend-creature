extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「高级塞壬」测试者β型"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atkRan = 5  #攻击距离
	attCoe.maxHp = 130   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 20	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 20  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）

	addSkill("开局随机获得3件装备，每{cd}秒召唤一名随机4级舰娘，并使其继承自身装备", "援军", "yj", 10)
	addSkill("每{cd}秒使敌方物攻最高者对其自身普攻3次", "攻击测试", "atkTest2", 6)
	addSkill("每{cd}秒对当前目标周围2格的敌人造成[目标双防*3]的真实伤害", "防御测试", "defTest", 6)

	addSkill("测试者感知到即将到来的危险，受到的暴击伤害降低80%", "危险感知")
	addSkill("<限定>当受到致命伤害时，使攻击者代替自己去世，并恢复35%的血量", "命运颠倒")

	addSkill("每{cd}秒弱驱散自身所有负面状态", "塞壬", "sr", 4)
	isHead = true
	giftCha = "cex___al-testerb"
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
	var cha = summChara(sys.rndListItem(utils.lv4), true)
	if sys.rndPer(50) and cha.has_method("upgrade"):
		cha.upgrade()
		cha.upgraded = true

func sort2(a,b):
	if a.get("type") == "BOSS" && b.get("type") != "BOSS":
		return false
	return a.att.atk > b.att.atk

func _onBattleStart():
	._onBattleStart()
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("DEF")))

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.isCri:
		atkInfo.hurtVal *= 0.3
	if immuneable && atkInfo.hurtVal >= att.hp:
		healCha(self, atkInfo.atkCha.att.maxHp * 3)
		utils.createSkillTextEff("命运颠倒", position)
		atkInfo.hurtVal = 0
		immuneable = false
		forceKillCha(atkInfo.atkCha)

var immuneable = true
	