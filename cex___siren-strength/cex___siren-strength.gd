extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「高级塞壬」仲裁者·司特莲库斯·VIII"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atkRan = 5  #攻击距离
	attCoe.maxHp = 175   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 18	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 18  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）
	attAdd.spd += 0.8
	attAdd.atkR += 0.8
	attAdd.cri += 0.3
	addSkill("开局随机获得3件装备，每{cd}秒召唤一名随机4级舰娘，并使其继承自身装备", "援军", "yj", 10)
	addSkill("反弹25%物理伤害", "尖刺护甲")
	addSkill("点燃前方2列海域，任何进入该海域的敌人每秒都会受到[法强*3]的伤害，并赋予5层<烧蚀>", "火海")
	addSkill("每{cd}秒，对最左侧2列的敌人造成[法强*4]的伤害，并赋予5层<烧蚀>", "燃烬", "ranJin", 8)
	addSkill("每{cd}秒清除自身所有负面状态", "塞壬", "sr", 4)
	isHead = true

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="ranJin":
		ranJin()
	if id=="yj":
		yj()
	if id=="sr":
		sr()

func ranJin():
	for i in range(2):
		for j in range(6):
			var c = Vector2(i, j)
			var cha = matCha(c)
			if cha != null and cha.team != team:
				cha.addBuff(buffUtil.b_shaoShi.new(5))
				azurHurtChara(cha, min(cha.att.maxHp*1.4, att.mgiAtk*4), Chara.HurtType.MGI, Chara.AtkType.SKILL, "燃烬", true)

var skCells = []
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
	skCells.clear()
	for i in range(2):
		for j in range(6):
			var c = Vector2(cell.x - i - 1, j)
			if sys.main.isMatin(c):skCells.append(c)

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.hurtType == Chara.HurtType.PHY and atkInfo.hurtVal > 0 and atkInfo.atkCha != null and not atkInfo.atkCha.isDeath:
		azurHurtChara(atkInfo.atkCha, min(atkInfo.atkCha.att.maxHp * 0.25, atkInfo.hurtVal*0.25), Chara.HurtType.REAL, Chara.AtkType.EFF, "尖刺护甲")

func yj():
	var cha = summChara(sys.rndListItem(utils.lv4), true)
	if cha.has_method("upgrade"):
		cha.upgrade()
		cha.upgraded = true
	if difficult.difficult > 5:
		cha.addBuff(buffUtil.b_zhenFen.new(20))

var index = 2
func _upS():
	._upS()
	for i in skCells:
		var cha = matCha(i)
		if cha != null and cha.team != team:
			cha.addBuff(buffUtil.b_shaoShi.new(5))
			azurHurtChara(cha, min(cha.att.maxHp*1.5, att.mgiAtk*3), Chara.HurtType.MGI, Chara.AtkType.SKILL, "火海")

var flag2 = true
func _onDeath(atkInfo):
	._onDeath(atkInfo)
	if not flag2:return
	flag2 = false
	research.changeRData(40)			