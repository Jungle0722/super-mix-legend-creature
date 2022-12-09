extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「高级塞壬」清除者"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atkRan = 5  #攻击距离
	attCoe.maxHp = 150   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 15	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 15  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）
	addSkill("开局随机获得3件装备，每{cd}秒召唤一名随机4级舰娘，并使其继承自身装备", "援军", "yj", 16)
	addSkill("每次普攻向前方施放一次毁灭光束，造成[法强*4]的伤害", "璀璨星河")
	addSkill("每{cd}秒，使当前目标及周围(十字范围)的敌人眩晕3秒，并延长其技能冷却3秒", "存在消除", "existRemove", 8)
	addSkill("造成伤害时，赋予目标<禁疗>", "斩草除根")
	addSkill("每{cd}秒清除自身所有负面状态", "塞壬", "sr", 4)
	isHead = true

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="existRemove":
		existRemove()
	if id=="yj":
		yj()
	if id=="sr":
		sr()

func existRemove():
	if difficult.difficult < 3:return
	var chas = getCellChas(aiCha.cell, 1, 1)
	for i in chas:
		i.addBuff(buffUtil.b_xuanYun.new(3))
		for j in i.skills:
			j.nowTime -= 3

func _onBattleStart():
	._onBattleStart()
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("MGI")))
	addItem(sys.newItem(utils.getRandomItem("DEF")))
	if difficult.difficult > 3:
		for i in items:
			if i.get("upgraded") != null:
				i.upgrade()
			else:
				difficult.itemUpgrade(i)
		learnRndSkill()

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		var aiCell = Vector2(0, cell.y)
		var eff:Eff = newEff("sk_jiGuan", sprcPos)
		eff.sprLookAt(aiCha.global_position)
		eff.scale *= 3
		eff.normalSpr.position = Vector2(0, -20)
		eff.position = position
		var chas = utils.lineChas(cell, aiCha.cell, 10)
		for cha in chas:
			if cha.team != team:
				azurHurtChara(cha, min(cha.att.maxHp*1.2, att.mgiAtk*4), Chara.HurtType.MGI, Chara.AtkType.SKILL, "璀璨星河")
	if atkInfo.hitCha.hasBuff("b_reHp_p") == null:
		atkInfo.hitCha.addBuff(buffUtil.b_reHp.new(-10, self))

func yj():
	var cha = summChara(sys.rndListItem(utils.lv4), true)
	if sys.rndPer(50) and cha.has_method("upgrade") or difficult.difficult > 5:
		cha.upgrade()
		cha.upgraded = true
	if difficult.difficult > 5:
		cha.addBuff(buffUtil.b_zhenFen.new(20))

var flag2 = true
func _onDeath(atkInfo):
	._onDeath(atkInfo)
	if not flag2:return
	flag2 = false
	research.changeRData(40)
	var achiOther = base.getSetting("achiOther", [])
	if achiOther.has("corePlayer"):
		sys.main.player.addItem(sys.newItem("i_Hide_al_ps6"))