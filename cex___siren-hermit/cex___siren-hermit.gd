extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「高级塞壬」仲裁者·赫米忒·IX"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atkRan = 5  #攻击距离
	attCoe.maxHp = 220   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 20	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 20  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）
	attAdd.spd += 1
	attAdd.atkR += 0.5
	attAdd.suck += 0.2
	attAdd.penL += 0.5

	addSkill("开局随机获得3件装备", "援军")
	addSkill("受到来自正面的伤害降低80%，正斜面的伤害降低30%，背后的伤害提高50%，斜后方的伤害提高30%", "重点防御")
	addSkill("普攻时对当前目标同列的所有敌人同时造成普攻伤害", "横扫")
	addSkill("造成普攻伤害时，附带等额的魔法伤害", "罡风")
	addSkill("每{cd}秒，撕裂当前目标的护甲，使其护甲降低50%，并对周围两格的敌人造成2次普攻(会触发横扫)", "乱舞", "luanWu", 10)
	addSkill("每{cd}秒弱驱散自身所有负面效果", "塞壬", "sr", 3)

	isHead = true
	atkEff = "atk_gongJian"

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="luanWu":
		luanWu()
	if id=="sr":
		sr()

func luanWu():
	aiCha.addBuff(buffUtil.b_defL.new(-5, 5))
	for i in getCellChas(aiCha.cell, 2, 1):
		normalAtkChara(i)

func normalAtkChara(cha):
	for i in range(6):
		var c = Vector2(cha.cell.x, i)
		var cha2 = matCha(c)
		if cha2 != null and cha.team != team:
			.normalAtkChara(cha2)

func _onBattleStart():
	._onBattleStart()
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("DEF")))
	if difficult.difficult > 2:
		for i in items:
			if i.get("upgraded") != null:
				i.upgrade()
			else:
				difficult.itemUpgrade(i)
		learnRndSkill()

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	var c = atkInfo.atkCha.cell
	if c.y == cell.y and c.x < cell.x:
		#正前方
		atkInfo.hurtVal *= 0.2
	elif c.y == cell.y and c.x > cell.x:
		#正后方
		atkInfo.hurtVal *= 1.5
	elif c.x < cell.x:
		#正斜面
		atkInfo.hurtVal *= 0.7
	else:
		#反斜面
		atkInfo.hurtVal *= 1.3

var flag2 = true
func _onDeath(atkInfo):
	._onDeath(atkInfo)
	if not flag2:return
	flag2 = false
	research.changeRData(40)

func _onAtkInfo(atkInfo):
	._onAtkInfo(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL and atkInfo.hurtType == Chara.HurtType.PHY:
		azurHurtChara(atkInfo.hitCha, atkInfo.atkVal, Chara.HurtType.MGI, Chara.AtkType.SKILL, "罡风")
	