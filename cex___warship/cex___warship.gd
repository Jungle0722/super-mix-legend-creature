extends "../azurline_ctrl/chaInfo.gd"
func _info():
	pass
func _connect():
	._connect()
	pass

#是否吃长门花嫁的buff
var cmBuffFlag = true
#是否被雪风承伤
var xfSkillFlag = true
#杀敌数
var killNum:int = 0

#周围一格
var aroundCells = [Vector2(-1,0),Vector2(1,0),Vector2(0,1),Vector2(0,-1),Vector2(1,1),Vector2(-1,-1),Vector2(1,-1),Vector2(-1,1)]
func getAroundChas(cell, allys = true):
	var chas = []
	for i in aroundCells:
		var cha = matCha(cell+i)
		if cha != null && (allys && cha.team == team || not allys && cha.team != team):
			chas.append(cha)
	return chas
#周围十字范围
var nearCells = [Vector2(-1,0),Vector2(1,0),Vector2(0,1),Vector2(0,-1)]
func getNearChas(cell, allys = true):
	var chas = []
	for i in nearCells:
		var cha = matCha(cell+i)
		if cha != null && (allys && cha.team == team || not allys && cha.team != team):
			chas.append(cha)
	return chas
	

#x轴最大坐标
var mX = 5
#y轴最大坐标
var mY = 9

var battleExp:int = 0
var unlock:bool = false
#献祭进化
var supportSpecEvo = 0
#战士的心得进化
var itemEvoCha
#星云舞裙进化
var itemEvoCha2
#场上μ兵装角色数量
var miuNum = 0
#是否为进化临时素材
var onEvo = false

#设置主炮与装甲类型
func setGunAndArmor(gunType, armorType):
	self.gunType = gunType
	setArmor(armorType)
	gunRate = utils.getRateByGunType(gunType)
	if gunRate == null:
		gunRate = [1, 1, 1, 1]

func setArmor(armorType):
	if armorType == "重型" and relic.heavyArmorFlag or armorType == "中型" and relic.mediumArmorFlag:
		self.armorType = "超重型"
	else:
		self.armorType = armorType

#获得当前伤害系数
func getGunToArmorRate(armorType):
	if armorType == "轻型":
		return gunRate[0]
	elif armorType == "中型":
		return gunRate[1]
	elif armorType == "重型":
		return gunRate[2]
	elif armorType == "超重型":
		return gunRate[3]
	elif armorType == "残破":
		return 1.3
	else:
		return 1

#移动特效
func ying(pos):
	var l:Vector2 = pos - position
	var s = 25
	var rs = preload("res://core/ying.tscn")
	var n = l.length()/s
	for i in range(n):
		var spr = rs.instance()
		sys.main.map.add_child(spr)
		spr.texture = img.texture
		spr.position = position + s * (i+1) * l.normalized() - Vector2(img.texture.get_width()/2,img.texture.get_height())
		spr.init(255/n * i + 100)

func sortByMaxHp(a,b):
	return  a.att.maxHp < b.att.maxHp

func sortByMaxHpDesc(a,b):
	return  a.att.maxHp > b.att.maxHp

func sortByFront(a,b):
	if team == 1:
		return a.cell.x > b.cell.x
	else:
		return a.cell.x < b.cell.x

func sortByHp(a,b):
	return (!a.isSumm && b.isSumm && a.att.maxHp - a.att.hp > 50) || a.att.hp / a.att.maxHp < b.att.hp / b.att.maxHp

func sortByNowHp(a,b):
	return (!a.isSumm && b.isSumm && a.att.maxHp - a.att.hp > 50) || a.att.hp < b.att.hp

func sortByHpDesc(a,b):
	return (!a.isSumm && b.isSumm && a.att.maxHp - a.att.hp > 50) || a.att.hp / a.att.maxHp > b.att.hp / b.att.maxHp

func sortByDistance(a,b):
	return cellRan(a.cell,cell) < cellRan(b.cell,cell)

func sortByDistanceDesc(a,b):
	return cellRan(a.cell,cell) > cellRan(b.cell,cell)

func sortByAtkDesc(a,b):
	return a.att.atk > b.att.atk

func sortByMgiAtkDesc(a,b):
	return a.att.mgiAtk > b.att.mgiAtk

func sortByAtk(a,b):
	return a.att.atk < b.att.atk

func sortByMgiAtk(a,b):
	return a.att.mgiAtk < b.att.mgiAtk

func sortByLv(a,b):
	return a.lv < b.lv

func sortByLvDesc(a,b):
	return a.lv > b.lv

func sortBySwDesc(a,b):
	return a.att.atk + a.att.mgiAtk + a.att.def + a.att.mgiDef > b.att.atk + b.att.mgiAtk + b.att.def + b.att.mgiDef

func sortByAllAtkDesc(a,b):
	return a.att.atk + a.att.mgiAtk > b.att.atk + b.att.mgiAtk

func sortByDef(a,b):
	return a.att.def < b.att.def

#默认1敌人
func getFirstCha(team = 1, key = "sortByMaxHp", excludeSiren = false, eraseMe = false, excludeSumm = false):
	var chas = getAllChas(team)
	if eraseMe:chas.erase(self)
	if chas == null or chas.empty():return null
	chas.sort_custom(self, key)
	for i in chas:
		if i.isDeath or i.att.hp < 0:
			continue
		if excludeSiren and (i.get("type") == "siren" or i.get("type") == "BOSS"):
			continue
		if excludeSumm and i.isSumm:
			continue
		return i
	return null
	
func _onKillChara(atkInfo:AtkInfo):
	._onKillChara(atkInfo)
	if not atkInfo.hitCha.isSumm:killNum += 1
	if not atkInfo.hitCha.isSumm && team == 1:
		azurCtrl.plusPt(1)
		var rnd = sys.rndRan(1, 1000)
		if rnd <= 11:
			utils.getRandomSkillBook()		
	
	if chaName.find("μ兵装") > -1 and atkInfo.hitCha.get("type") == "BOSS":
		var rnd = sys.rndRan(1, 1000)
		if atkInfo.hitCha.get("isHead") == true:
			if rnd <= 500:sys.main.player.addItem(sys.newItem(sys.rndListItem(utils.consts.miuEquips)))
		else:
			if rnd <= 50:sys.main.player.addItem(sys.newItem(sys.rndListItem(utils.consts.miuEquips)))

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	var at = atkInfo.hitCha.get("armorType")
	if at != null:
		atkInfo.hurtVal *= getGunToArmorRate(at)

var enableDeath = true
func _onDeath(atkInfo):
	._onDeath(atkInfo)
	if team == 2 && skillSlot != null:
		skillSlot.remove()
		skillSlot = null	
	if not enableDeath or not isDeath:return
	enableDeath = false
	call("deathWord")
	if relic.deathWordBonus and team == 1:
		call("deathWord")	

func deathWord():
	pass

func _onBattleStart():
	._onBattleStart()
	damageData = {}
	dpsData = {}
	hurtData = {}
	skillNum = {}
	achieveRealLove()
	checkMiuChara()
	emit_signal("onBattleStart")
	yield(reTimer(0.1),"timeout")
	call("_onBattleStart2")
#回合开始时：延迟启动
func _onBattleStart2():
	pass

func achieveRealLove():
	if team == 2:return
	checkRealLove()
	if realLoveFlag:
		addBuff(b_realLove.new())
		plusHp(att.maxHp)

func _upS():
	._upS()
	if isDeath:return
	emit_signal("upS")
	#血量为负时，执行补偿机制
	if att.hp <= 0:
		changeShield(-shield)
		hurtChara(self, 0, Chara.HurtType.REAL, Chara.AtkType.EFF)
	if att.maxHp <= 0 and att.hp > 0:
		changeShield(-shield)
		att.hp = 0
		hurtChara(self, 0, Chara.HurtType.REAL, Chara.AtkType.EFF)
	#超时加伤机制
	battleTime += 1
	if team == 1 and battleTime > azurCtrl.lastTime:
		azurCtrl.lastTime = battleTime
	if battleTime > 100:
		var buff = hasBuff("b_atkR_diff")
		if buff == null:
			buff = addBuff(buffUtil.b_atkR_diff.new(0.1))
		else:
			buff.att.atkR += 0.01
			if att.reHp > -0.2:
				buff.att.reHp -= 0.01
#战斗时间
var battleTime = 0
#===============================技能统计相关=======================================
func _onHurtEnd(atkInfo):
	if atkInfo.hurtVal > 0 && not atkInfo.isMiss and atkInfo.atkCha.team != atkInfo.hitCha.team:
		atkInfo.hurtVal = min(atkInfo.hitCha.att.maxHp, atkInfo.hurtVal)
		var fix = atkInfo.hitCha.att.hp
		if atkInfo.atkCha.isSumm and atkInfo.atkCha.get("summoner") != null:
			atkInfo.atkCha.summoner.damageCallback2(atkInfo)
			var atkStatis = azurCtrl.getStatisByCha(atkInfo.atkCha.summoner) 
			atkStatis.damage += atkInfo.hurtVal
			azurCtrl.setStatisByCha(atkInfo.atkCha.summoner, atkStatis)
		if not atkInfo.atkCha.isSumm:
			atkInfo.atkCha.damageCallback(atkInfo)
			var atkStatis = azurCtrl.getStatisByCha(atkInfo.atkCha) 
			atkStatis.damage += atkInfo.hurtVal
			azurCtrl.setStatisByCha(atkInfo.atkCha, atkStatis)
		if not atkInfo.hitCha.isSumm:
			var hitStatis = azurCtrl.getStatisByCha(atkInfo.hitCha)
			hitStatis.hurt += atkInfo.hurtVal
			azurCtrl.setStatisByCha(atkInfo.hitCha, hitStatis)

func _init():
	._init()
	connect("onHurtEnd", self, "_onHurtEnd")

#增加人物治疗量统计量
func increDealNum(num):
	var statis = azurCtrl.getStatisByCha(self)
	statis.deal += num
	azurCtrl.setStatisByCha(self, statis)
#增加人物伤害统计量
func increDmgNum(num, name = null, hitCha = null):
	var atkStatis = azurCtrl.getStatisByCha(self) 
	atkStatis.damage += num
	azurCtrl.setStatisByCha(self, atkStatis)
	if name == null:name = "其它"
	doDamageCallback(num, name, hitCha)

#===============================技能槽相关=======================================
#最强之盾伤害储存
var storage = 0
#技能倾向
var prefer
#技能槽
var skillSlot
#阅读技能书
func setSkill(skill, item):
	yield(reTimer(0.1),"timeout")
	if lv < 3 || skill.excludeChas.has(self.id) ||not detectSkills(skill):
		#读书失败
		delItem(item)
		return
	sys.main.player.delItem(item)

func fillSlot(skill):
	if skill.tcha == null:
		skill.setCha(self)
	if skillSlot != null:
		skillSlot.remove()
	skillSlot = skill
	skillStrs[0] = "{0}[{1}{2}]:{3}".format({"0":color[skill.rarity],"1":skill.sname,"2":getPrefix(skill.rarity),"3":skill.text})

func getPrefix(rarity):
	match rarity:
		1:
			return "·Lv1"
		2:
			return "·Lv2"
		3: 
			return "·Lv3"

var father = null
var initable = true
#自动获得技能
var slotText = "[空技能槽]-阅读技能书以填充此栏位"
var color = ["[color=#7FFF00]","[color=#7B68EE]","[color=#FF00FF]","[color=#FFFF00]"]
func autoGetSkill():
	if sys.main == null || team == 2:return
	if skillSlot != null:
		skillStrs.push_front("{0}[{1}{2}]:{3}".format({"0":color[skillSlot.rarity],"1":skillSlot.sname,"2":getPrefix(skillSlot.rarity),"3":skillSlot.text}))
		return
	var father = self.get_parent()
	if father == null:return
	if father.get("id") != self.id and checkEmptySkillSlot():
		skillStrs.push_front(color[0] + slotText)

#检查空技能槽
func checkEmptySkillSlot():
	for i in skillStrs:
		if i.find(slotText) > -1:return false
	return true

func enemyGetSkill(s = null):
	if checkEmptySkillSlot():
		skillStrs.push_front(color[0] + slotText)
	var skill
	if s == null:
		skill = skillPool.getRandomSkill(utils.getRandomRarity(10), prefer)
	else:
		skill = skillPool.getSkill(s.sid, s.rarity)
	detectSkills(skill)
	return skill

#检测并赋予角色技能
func detectSkills(skill):
	var flag = false
	if skillSlot == null || skillSlot.sid == skill.sid && skill.rarity > skillSlot.rarity || skillSlot.sid != skill.sid:
		flag = true
		fillSlot(skill)
	elif skillSlot.sid == skill.sid && skill.rarity == skillSlot.rarity:
		flag = true
		#执行技能升级
		var r = skill.rarity + 1
		if r < 4:
			var s = skillPool.skills.get(skill.sid).new(r)
			fillSlot(s)
		else:
			utils.getRandomSkillBook(r)
	return flag

signal upS
signal normalAtkChara
func normalAtkChara(cha):
	emit_signal("normalAtkChara", cha)
	.normalAtkChara(cha)

func normalAtk(cha):
	.normalAtkChara(cha)

signal onBattleStart
signal onBattleEnd
func _onBattleEnd():
	._onBattleEnd()
	emit_signal("onBattleEnd")
	miuNum = 0
	battleTime = 0
	changeShield(-shield)
	campTmp = null
	forceHurtFlag = false
	enableDeath = true
	sirenEndCheck()

func reCreate():
	var js = toJson()
	var cha = sys.main.newChara(id)
	var itemsArr = []
	for i in items:
		itemsArr.append(i)
	for i in buffs:
		if i.get("type") != config.EQUITYPE_EQUI:
			cha.addBuff(i)
	var node = get_parent()
	remove()
	cha.isItem = isItem
	node.add_child(cha)
	cha.position = position
	cha.cell = cell
	cha.oldCell = oldCell
	cha.isDrag = isDrag
	if not isItem:
		sys.main.setMatCha(cha.cell, cha)
	for i in itemsArr:
		cha.addItem(i)
	# if cha.has_method("extendsEvo"):
	# 	cha.extendsEvo(self)
	cha.fromJson(js, false)

func _extInit():
	._extInit()
	if team == 1:
		unlock = true
	tpViewInit()

func levelUp():
	level += 1
	chaName = chaName.rsplit("Lv")[0] + "Lv%d"%level
#强制杀死
func forceKillCha(cha):
	cha.forceHurtSelf(cha.att.maxHp)
	cha.hurtChara(cha, 1, Chara.HurtType.REAL, Chara.AtkType.EFF)

#战败相关机制
func _onCharaDel(cha):
	if not is_instance_valid(cha):return
	if cha == self and utils.isChallengeMode() and team == 1 and not isSumm:
		var d = {"id":id, "items":[]}
		for i in items:
			d.items.append(i.id)
		difficult.deathChas.append(d)
	if isDeath || cha.team != 1:return
	if getAllChas(1).size() == 1:
		#玩家战败通用逻辑
		if difficult.step > 161:
			pvp.upload(difficult.step)

func yieldOnReach(d):
	yield(d,"onReach")

func setAiCha(cha):
	if cha.hasBuff("b_vague") != null and cha.team != team:
		var chas = getAllChas(1)
		chas.sort_custom(self, "sortByDistance")
		chas.erase(cha)
		for i in chas:
			if i.hasBuff("b_vague") != null:continue
			cha = i
			break
	.setAiCha(cha)

func forceHurtSelf(num):
	forceHurtFlag = true
	plusHp(-num/(att.reHp+1))
	forceHurtFlag = false
	hurtChara(self, 1, Chara.HurtType.REAL, Chara.AtkType.EFF)

func updateTmpAtt(att, num, upAtt = true):
	attEx.set(att, attEx.get(att) + num)
	if upAtt:upAtt()

#真爱成就
class b_realLove:
	extends Buff
	var buffName = "真爱"
	var dispel = 2
	func _init():
		attInit()
		id = "b_realLove"
		att.atkL = 0.12
		att.mgiAtkL = 0.12
		att.defL = 0.12
		att.mgiDefL = 0.12
		att.maxHpL = 0.12

#创建指向性飞行特效
func createFlyEff(from, to, src, onReach = true):
	if difficult.step >= 100:
		return
	var d:Eff = newEff(src, from)
	d._initFlyCha(to)
	if onReach:
		yieldOnReach(d)

#创建指向性特效
func createDirectEff(to, src):
	if difficult.step >= 100:
		return
	var eff:Eff = newEff(src)
	eff.position = to

#创建自定义特效
func createCustEff(from, src, spd, loop = false, scale = null, pos = null):
	if difficult.step >= 100:
		return null
	var d1:Eff = sys.newEff("animEff", from)
	d1.setImgs(direc + src, spd, loop)
	if scale != null:
		d1.scale *= scale
	if position != null:
		d1.normalSpr.position = pos
	return d1

#将角色信息转为字典
func toJson():
	var json = {}
	json["id"] = id
	json["chaName"] = chaName
	json["level"] = level
	json["battleExp"] = battleExp
	json["killNum"] = killNum
	json["rndId"] = rndId
	json["crewExp"] = crewExp
	json["crewLv"] = crewLv
	json["crewMaxLv"] = crewMaxLv
	json["crewEquip"] = crewEquip
	json["crewEquipName"] = crewEquipName
	json["isAwaken"] = isAwaken
	json["realCamp"] = realCamp
	json["attEx"] = attEx.info
	json["attFx"] = attFx.info
	json["maxItem"] = maxItem
	if not exSkillSlot.empty():
		var ex = []
		for i in exSkillSlot:
			ex.append(i.toJson())
		json["exSkillSlot"] = ex

	if get("upgraded") != null:
		json["upgraded"] = upgraded

	if get("awakenProcess") != null:
		json["awakenProcess"] = get("awakenProcess")

	if skillSlot != null:
		json["skId"] = skillSlot.sid
		json["sklv"] = skillSlot.rarity
	if utils.inBattle(self):
		if oldCell == Vector2(0, 0) or oldCell == null:
			json["cell"] = cell
		else:
			json["cell"] = oldCell

	return json
#从字段中还原角色信息
func fromJson(json, setCell = true):
	chaName = json.get("chaName")
	level = json.get("level")
	battleExp = json.get("battleExp")
	killNum = json.get("killNum")
	rndId = json.get("rndId")
	if json.has("realCamp"):
		realCamp = json.get("realCamp")
		if realCamp != null:
			setCamp(realCamp)
	crewExp = json.get("crewExp")
	crewLv = json.get("crewLv")
	crewMaxLv = json.get("crewMaxLv")
	crewEquip = json.get("crewEquip")
	crewEquipName = json.get("crewEquipName")
	isAwaken = json.get("isAwaken")
	maxItem = json.get("maxItem")
	if lv >= 3 and json.has("skId"):
		var sk = skillPool.getSkill(json.get("skId"), json.get("sklv"))
		enemyGetSkill(sk)

	if json.has("exSkillSlot"):
		for i in json.exSkillSlot:
			var sk = skillPool.getSkill(i.get("sId"), i.get("slv"))
			exSkillSlot.append(sk)
			sk.setCha(self)

	if json.has("cell") and setCell:
		var cl = utils.stringToVector(json.get("cell"))
		cell = cl
		setCell(cell)
		position = sys.main.map.map_to_world(cl)

	if json.has("awakenProcess"):
		set("awakenProcess", json.get("awakenProcess"))
		if isAwaken:
			call("awaken")
			
	if json.has("attEx"):
		var attExInfo = json.get("attEx")
		for i in attExInfo.keys():
			attEx.set(i, attEx.get(i) + attExInfo.get(i))
		upAtt()

	if json.has("attFx"):
		var attFxInfo = json.get("attFx")
		for i in attFxInfo.keys():
			attFx.set(i, attFx.get(i) + attFxInfo.get(i))
		upAtt()

	if json.has("upgraded"):
		self.set("upgraded", json.upgraded)
		if has_method("upgrade") and json.upgraded:
			call("upgrade")

#进化后继承属性
func extendsEvo(cha):
	if crewEquipName == "量产型舰载机" and cha.crewEquipName != "量产型舰载机":
		crewEquip = cha.get("crewEquip")
		crewEquipName = cha.get("crewEquipName")
		crewMaxLv = cha.get("crewMaxLv")
		crewLv = int(cha.get("crewLv") * 0.5)

	if lv >= 3 and cha.skillSlot != null:
		var sk = skillPool.getSkill(cha.skillSlot.sid, cha.skillSlot.rarity)
		enemyGetSkill(sk)
	#继承额外属性
	fuseAttEx(cha.attEx)
	upAtt()

#μ兵装羁绊额外检查
func checkMiuCondition():
	for i in items:
		if i.id == "i_Hide_al_awakeningPeal":
			return true
	return false
#缪兵装羁绊
var finalAwaken = false
func checkMiuChara():
	if chaName.find("μ兵装") > -1:
		var allMiu = false
		miuNum = 0
		for i in getAllChas(2):
			if i.chaName.find("μ兵装") > -1:
				miuNum += 1
		if miuNum >= 10:
			allMiu = true
		miuNum += azurCtrl.miuProject
		call("resetAwaken")
		if miuNum >= 2 or checkMiuCondition():
			call("jiBan1")
		if miuNum >= 5 or checkMiuCondition():
			call("jiBan2")
		if miuNum >= 8 or checkMiuCondition():
			call("jiBan3")
		finalAwaken = false
		if azurCtrl.allStar and allMiu:
			finalAwaken = true
			call("finalAwaken")
#额外学习随机技能
func learnRndSkill():
	var sk = skillPool.getRandomSkill(3, prefer)
	while sk.excludeChas.has(id) or team == 2 and sk.enableAi == false:
		sk = skillPool.getRandomSkill(3, prefer)
	exSkillSlot.append(sk)
	sk.setCha(self)

func maxHp(cha):
	if cha == null:return 0
	return min(40000, cha.att.maxHp)

#暴击总开关	
var criFlag = false
func _onAtkInfo(atkInfo):
	._onAtkInfo(atkInfo)
	if atkInfo.atkCha == self and criFlag:
		atkInfo.canCri = true	
	emit_signal("onAtkInfo", atkInfo)
#弱驱散
func weakDispel(cha, isNegetive):	
	for j in cha.buffs:
		if isNegetive and not j.isNegetive or not isNegetive and j.isNegetive:continue
		if j.get("type") != config.EQUITYPE_EQUI && j.get("dispel") != 2 and j.get("dispel") != 3 or j.id == "b_shengDun":
			j.isDel = true
#造成神圣伤害
func holyDmg(cha, num, name):
	if cha.get("type") == "BOSS":
		num = min(cha.att.maxHp*0.1, num)
	var statisNum = min(cha.att.hp, num)
	increDmgNum(statisNum, name, cha)			
	cha.forceHurtSelf(num)
	hurtChara(cha, 1, Chara.HurtType.REAL, Chara.AtkType.EFF)

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	#所有角色15%减伤
	atkInfo.hurtVal *= 0.85

#融合AttEx
func fuseAttEx(att):
	for i in self.attEx.info.keys():
		self.attEx.set(i, self.attEx.get(i) + att.get(i))	

func sirenEndCheck():
	if type != "siren":return
	battleExp += 1
	if gSiren.sirenAwaken:
		battleExp += 1
		if sys.rndPer(35):
			battleExp += 1
	if gSiren.darkFood and sys.rndPer(50):
		battleExp += 1
	if lv == 4:
		if level < 20 and battleExp >= 6:
			self.levelUp()
			battleExp -= 6
	else:
		if battleExp >= 18:
			utils.evoCha(self, self.evos[0])