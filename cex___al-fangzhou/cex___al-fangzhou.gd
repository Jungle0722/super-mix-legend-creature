extends "../azurline_ctrl/carrier.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「航母」皇家方舟·Meta·Lv%d"%level   #角色的名称
	attCoe.atkRan = 4#攻击距离
	attCoe.maxHp = 5#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 3     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 5  #魔法攻击（每点代表13.7）
	attCoe.def = 4     #物理防御（每点代表15）
	attCoe.mgiDef = 4#魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	atkEff = "atk_dang" #攻击时的特效
	setGunAndArmor("小型","重型")
	setCamp("塞壬")
	lv = 3             #等级的设置
	evos = ["cex___al-fangzhou2"]

	addSkill("每{cd}秒起飞一架受自身双攻加成的<舰载机>(←点击可查看说明)", "舰载机", "castPlane", 12)
	addSkill("每{cd}秒对随机3个敌人的方向射出3发枪焰，分别对直线上的敌人造成[法强*2]({damage})的伤害，\n					并附带10层漏水", "烬火枪焰", "sk_fangzhou1", 8)
	addSkill("每{cd}秒对随机三分之一的敌人进行标记，若敌人被标记2次，则造成[法强*4]({damage})的真实伤害，\n					被标记3次，则直接受到[血上限100%]的真实伤害", "幻影强袭", "sk_fangzhou2", 8)

	if id == "cex___al-fangzhou":
		addSkillTxt("[color=#C0C0C0]参加18场战斗后，将进化为传奇单位[/color]")
	type = "siren"
	canCopy = false
	ename = "heifangzhou"

func castPlane():
	var summ = summPlane()
	if lv == 1:return summ
	if summ != null && not summ.isDeath and team == 1:
		var ap = float(att.mgiAtk + att.atk)
		summ.attAdd.maxHp += (ap/6.0)*lv
		summ.plusHp((ap/6.0)*lv)
		summ.attAdd.def = (ap/7.0)*lv
		summ.attAdd.mgiDef = (ap/7.0)*lv
		summ.attAdd.atk = (ap/5.5)*lv
		summ.attAdd.mgiAtk = (ap/5.5)*lv
		summ.upAtt()
	return summ	
	
func levelUp():
	.levelUp()
	updateAtt()

func updateAtt():
	updateTmpAtt("maxHp", 100, false)
	updateTmpAtt("atk", 10, false)
	updateTmpAtt("mgiAtk", 10, false)
	updateTmpAtt("def", 10, false)
	updateTmpAtt("mgiDef", 10, false)
	if level == 20 and gSiren.sirenAwaken:
		call("awaken")
		updateTmpAtt("maxHp", 1000, false)
		updateTmpAtt("atk", 100, false)
		updateTmpAtt("mgiAtk", 100, false)
		updateTmpAtt("def", 100, false)
		updateTmpAtt("mgiDef", 100, false)
		updateTmpAtt("cd", 0.35, false)
	upAtt()

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "sk_fangzhou1":
		sk_fangzhou1()
	if id == "sk_fangzhou2":
		sk_fangzhou2()
	if id=="castPlane":
		self.castPlane()

#烬火枪焰
func sk_fangzhou1():
	var chas = utils.getRndEnemys(self, 3)
	for i in chas:
		yield(reTimer(0.2),"timeout")
		var eff2:Eff = sys.newEff("animEff", position)
		eff2.setImgs(direc + "eff/thunderFly", 9, true)
		eff2._initFlyPos(position + (aiCha.position - position).normalized() * 1000, 350)
		eff2.normalSpr.position=Vector2(0, -30)
		eff2.connect("onInCell",self,"effInCell")

func effInCell(cell):
	var cha = matCha(cell)
	if cha == null:
		cha = matCha(cell + Vector2(0, 1))
	if cha != null && cha.team != team :
		var dmg = getSkillEffect("烬火枪焰")
		azurHurtChara(cha, dmg, Chara.HurtType.MGI, Chara.AtkType.SKILL, "烬火枪焰")
		buffUtil.addLouShui(cha, self, 20)
var flagedChas = {}
#幻影强袭
func sk_fangzhou2():
	var chas = getAllChas(1)
	var index = 0
	for i in chas:
		if index > chas.size()/3:break
		if i.get("tag") != "azurline":continue
		index += 1
		utils.dicPlus(flagedChas, i, 1)
		if flagedChas.get(i) == 2:
			azurHurtChara(i, att.mgiAtk * 4, Chara.HurtType.REAL, Chara.AtkType.SKILL, "幻影强袭")
		elif flagedChas.get(i) > 2:
			azurHurtChara(i, i.att.maxHp*1, Chara.HurtType.REAL, Chara.AtkType.SKILL, "幻影强袭")

func _onBattleEnd():
	._onBattleEnd()
	flagedChas = {}
	# flag = 0
	# if type != "siren":return
	# battleExp += 1
	# if gSiren.sirenAwaken:
	# 	battleExp += 1
	# if gSiren.darkFood and sys.rndPer(50):
	# 	battleExp += 1
	# if lv == 4:
	# 	if level < 20 and battleExp >= 6:
	# 		self.levelUp()
	# 		battleExp -= 6
	# else:
	# 	if battleExp >= 18:
	# 		utils.evoCha(self, self.evos[0])

func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "烬火枪焰":
		return att.mgiAtk * 2
	elif name == "幻影强袭":
		return att.mgiAtk * 4