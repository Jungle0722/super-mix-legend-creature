extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战斗机」量产型舰载机"   #角色的名称
	attCoe.atkRan = 2  #攻击距离
	attCoe.maxHp = 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 2     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 2  #魔法攻击（每点代表13.7）
	attCoe.def = 1     #物理防御（每点代表15）
	attCoe.mgiDef = 0 #魔法防御（每点代表16.6）
	lv = 2             #等级的设置
	atkEff = "atk_dang" #攻击时的特效
	isSumm = true
	prefer = "fighter"
	type = "plane"

var summoner
var flag = false
var zuikakuFlag = null
var additionSkill
func _onNormalAtk(cha):
	._onNormalAtk(cha)
	changeExp(2)
	
func _onKillChara(atkInfo):
	._onKillChara(atkInfo)
	changeExp(4)

func _onDeath(atkInfo):
	._onDeath(atkInfo)
	changeExp(-2)
	if zuikakuFlag != null and aiCha != null:
		hurtChara(aiCha, (att.atk+att.mgiAtk)*1, Chara.HurtType.REAL, Chara.AtkType.EFF)

func _castCdSkill(id):
	._castCdSkill(id)
	changeExp(4)
	if id == "kyfz":
		kyfz()

func changeExp(num):
	if summoner == null or summoner.lv < 3:return
	summoner.crewExp = max(0, summoner.crewExp + num*summoner.summExpBonus)
	if summoner.crewExp >= 100:
		var exLv = 0
		if azurCtrl.crewTraining:
			exLv = 10
		summoner.crewExp = 0
		summoner.crewLv = min(summoner.crewMaxLv + exLv, summoner.crewLv + 1)

func updateAtt():
	if team == 2:return
	if azurCtrl.crewTraining && skillSlot == null && summoner.crewLv >= 10 && team == 1 and summoner != null and summoner.skillSlot != null:
		#赋予随机技能
		enemyGetSkill(summoner.skillSlot)

	if summoner.crewLv != 0:
		var p = 0.1
		attAdd.atk = (summoner.crewLv)*p*att.atk
		attAdd.mgiAtk = (summoner.crewLv)*p*att.mgiAtk
		attAdd.def = (summoner.crewLv)*p*att.def
		attAdd.mgiDef = (summoner.crewLv)*p*att.mgiDef
		attAdd.maxHp = (summoner.crewLv)*p*att.maxHp

		var p2 = 0
		if summoner.crewLv >= 10:
			p2 = 0.15
			match prefer:
				"fighter":
					attAdd.dod = p2
					attAdd.defR = p2
					attAdd.maxHpL = p2
				"cas":
					attAdd.penL = p2
					attAdd.spd = p2
					attAdd.defR = p2
				"tbf":
					attAdd.mgiPenL = p2
					attAdd.cd = p2
					attAdd.defR = p2
		plusHp(attAdd.maxHp)
		upAtt()
		
#空域辅助
func kyfz():
	var chas = getAllChas(2)
	chas.sort_custom(self, "sortByHp")
	var dmg = (att.atk + att.mgiAtk) * 1.5
	for i in range(3):
		if i >= chas.size() : break
		healCha(chas[i], dmg)		
		if summoner != null and summoner.upgraded and sys.rndPer(10):
			var bf = chas[i].hasBuff("b_independence")
			if bf != null:
				bf.num += 1
			else:
				chas[i].addBuff(buffUtil.b_independence.new(1, summoner))