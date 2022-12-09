extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
var isHead = false
func _extInit():
	._extInit()
	chaName = "基础BOSS"   #角色的名称
	attCoe.atkRan = 5  #攻击距离
	attCoe.maxHp = 8   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 4     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 4  #魔法攻击（每点代表13.7）
	attCoe.def = 4     #物理防御（每点代表15）
	attCoe.mgiDef = 4 #魔法防御（每点代表16.6）
	lv = 1             #等级的设置
	atkEff = "atk_dang" #攻击时的特效
	addSkillTxt("[试炼]-单次受伤量不超过最大生命值的30%")
	type = "BOSS"
	setGunAndArmor("大型","重型")
	setCamp("塞壬")
	
var baseId = ""
var giftCha = null

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.hurtVal > att.maxHp * 0.2:
		atkInfo.hurtVal = att.maxHp * 0.2
	if difficult.difficult > 1 and (difficult.step > 55 or difficult.difficult == 7):
		atkInfo.hurtVal *= 0.85
		if difficult.difficult == 7:
			atkInfo.hurtVal *= 0.85

func _onBattleEnd():
	._onBattleEnd()
	flag = true

#通用死亡掉落
var flag = true
var giftBonus = 1
func _onDeath(atkInfo):
	._onDeath(atkInfo)
	if not flag or isSumm:return
	flag = false
	#掉落PT点
	if difficult.difficult < 7:
		azurCtrl.pt += 5*giftBonus
	#掉落技能书
	if sys.rndPer(lv*2):
		utils.getRandomSkillBook()
	if sys.rndPer(lv+12) && not isHead:
		sys.main.player.addItem(sys.newItem(utils.getRandomItem("RARE")))

	if isHead:
		#高级塞壬
		research.changeRData(30)
		if difficult.difficult < 7:
			azurCtrl.pt += 80*giftBonus
		if giftCha != null:
			var cha = sys.main.newChara(giftCha)
			sys.main.player.addCha(cha)
			gSiren.challengeSuccess(id, cha)
			sys.main.player.addItem(sys.newItem(utils.getRandomItem("RARE")))
			#退场时带走自己所有小弟	
			for i in getAllChas(2):
				holyDmg(i, i.att.maxHp, "退场杀")
		else:
			if id == "cex___siren-builder" or id == "cex___siren-cleaner":
				sys.main.player.addItem(sys.newItem("i_Hide_al_equipBox"))
			else:
				sys.main.player.addItem(sys.newItem(utils.getRandomItem("RARE")))
	else:
		research.changeRData(3)

	if sys.rndPer(lv):
		var item = sys.newItem("i_Hide_plane")
		item.repair(true)
		sys.main.player.addItem(item)

#献祭
func xj():
	var chas = getAllChas(2)
	chas.sort_custom(self,"sort")
	for i in range(lv-2):
		if i >= chas.size() : break
		if chas[i].get("type") != "BOSS":
			attAdd.atk += chas[i].att.atk/2
			attAdd.mgiAtk += chas[i].att.mgiAtk/2
			attAdd.def += chas[i].att.def/2
			attAdd.mgiDef += chas[i].att.mgiDef/2
			hurtChara(chas[i], chas[i].att.maxHp, Chara.HurtType.REAL, Chara.AtkType.EFF)

func _onBattleStart():
	._onBattleStart()
	var step = difficult.step
	if step > 52:
		addItem(sys.newItem(utils.getRandomItem("DEF")))
	if step > 90:
		addItem(sys.newItem(utils.getRandomItem("MGI")))
	if step > 110:
		addItem(sys.newItem(utils.getRandomItem("PHY")))

func sr():
	for i in buffs:
		if i.isNegetive and i.get("dispel") != 2 and i.get("dispel") != 3:
			i.isDel = true

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.hitCha.isSumm:
		atkInfo.hurtVal *= 1.5