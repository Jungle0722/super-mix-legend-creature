
extends Node
func _ready():
	pass
func _init():
	call_deferred("alInit")
func _connect():
	pass
var azurCtrl = null
var base = null
var path = null
var gskill
var utils
var gSiren
var pvp
var research
func alInit():
	if globalData.infoDs.has("g_azurlineBase"):
		base = globalData.infoDs["g_azurlineBase"]
		path = chaData.infoDs["cazurlineA"].dir
	if base != null:
		#初始化
		utils = globalData.infoDs["g_azurlineUtils"]
		azurCtrl = globalData.infoDs["g_azurline"]
		gskill = globalData.infoDs["g_azurlineSkills"]
		gSiren = globalData.infoDs["g_azurlineSiren"]
		pvp = globalData.infoDs["g_azurlinePVP"]
		research = globalData.infoDs["g_azurlineResearch"]
		azurCtrl.connect("resetData", self, "resetData")

var step:int = 1
var difficult:int

func resetData():
	evoRnd = 0
	itemEvoRnd = 0
	hpProtect = -1
	difficult = int(base.getSetting("difficult2", 1))
	deathChas.clear()

#四维加成比例
var p1 = 2
#血量加成比例
var p2 = 15
#debuff比例
var p3 = 0.05
#旧难度因子
var factor:int = 1
#物品进化概率
var itemEvoRnd = 0
var evoRnd = 0
#血量保护
var hpProtect = -1

func setDiffParams(step, difficult):
	p1 = 1
	p2 = 5
	if difficult >= 2 and step > 40:
		p1 += (step - 40) * 0.007 * (factor - 4)
		p2 += (step - 40) * 0.14 * (factor - 4)
		p3 = min(0.4, (0.01 * (factor + 5)))
	if difficult >= 6 and step > 55:
		p2 *= 1.2
	if difficult >= 6 and step > 81:
		p2 *= 1.2	
	if difficult >= 6 and step > 108:
		p2 *= 1.2

	p1 *= step	
	p2 *= step

	evoRnd = 0
	match difficult:
		3:evoRnd = int(0.25 *step)
		4:evoRnd = int(0.375 *step)
		5:evoRnd = int(0.75 *step)
		6:evoRnd = int(1.25 *step)
		7:evoRnd = int(1.75 *step)
	evoRnd = min(30, evoRnd)

	#装备进化概率
	itemEvoRnd = evoRnd*0.5
	if step >= 75:
		itemEvoRnd *= 2
	elif step >= 105:
		itemEvoRnd *= 2
	itemEvoRnd = int(itemEvoRnd)

func getDiffFactor(difficult):
	match difficult:
		2:factor = 5
		3:factor = 10
		4:factor = 15
		5:factor = 25
		6:factor = 30
		7:
			if utils.isChallengeMode():
				factor = 40
			else:
				factor = 35

# #获得难度减伤系数
# func getDiff
func setHpProtect():
	if hpProtect != -1 or difficult >= 4:return
	match difficult:
		1:hpProtect = 0.25
		2:hpProtect = 0.5
		3:hpProtect = 0.75
#上回合我方阵亡角色，仅用于挑战模式
var deathChas = []
func difficultOption():
	step = sys.main.guankaMsg.lvStep - 2
	totalDef = 0
	if azurCtrl.layertxt != null:
		azurCtrl.layertxt.bbcode_text="当前层数：%d" % (step)
	difficult = int(base.getSetting("difficult2", 1))
	setHpProtect()
	getDiffFactor(difficult)
	if step <= 150 and difficult == 1:
		sys.main.player.plusGold(5)
		azurCtrl.plusPt(5)

	if step == 1 and difficult < 7:
		showHelp()

	#执行人物自动升级设定
	if difficult >= 3 && step > 45:
		for i in utils.getAllCells(2):
			var cha = sys.main.matCha(i)
			if cha != null && cha.team == 2 and cha.get("type") != "BOSS":
				if cha.evos.size() > 0 && sys.rndPer(evoRnd):
					var cha1 = sys.main.newChara(cha.evos[0], 2)
					sys.main.delMatChara(cha)
					sys.main.map.add_child(cha1)
					sys.main.setMatCha(i, cha1)
				if cha.lv == 4 and sys.rndPer(evoRnd*2) and cha.has_method("upgrade") and cha.get("upgraded") == false and step > 70:
					cha.upgrade()
					cha.upgraded = true

	setDiffParams(step, difficult)
	var chas = []
	for i in utils.getAllCells(2):
		var cha = sys.main.matCha(i)
		if cha != null:
			chas.append(cha)
	#挑战模式
	for i in deathChas:
		var cha = gSiren.createBoss(i.id)
		for j in i.items:
			cha.addItem(sys.newItem(j))
		chas.append(cha)
	deathChas.clear()
	for i in chas:
		doDiffBonus(i)
	azurCtrl.layertxt.bbcode_text += " [color=#DC143C]当前UP：%s"%azurCtrl.upChaName

var totalDef = 0
func doDiffBonus(cha):
	if cha.get("unlock") == false and difficult >= 3:
		cha.unlock = true
	if cha.team == 2:
		doAiChaBouns(cha)
	else:
		if difficult >= 4:
			if step > 81:
				#玩家单位DEBUFF
				cha.addBuff(b_N7.new(p3))
		if difficult == 1:
			cha.addBuff(b_easy.new(step))
	if difficult == 1:
		cha.plusHp(cha.att.maxHp)
	cha.upAtt()

func doAiChaBouns(cha):
	var defR = 0.99
	if difficult >= 2 and not cha.isSumm:
		if step > 110:
			cha.attAdd.atkR += (step - 110)/100.0
			cha.attAdd.atkR += factor/200.0
			cha.attAdd.defR += (step - 100)/200.0
			cha.attAdd.defR = min(0.4, cha.attAdd.defR)
	if difficult >= 2 and step > 50 and cha.get("type") != "BOSS":
		#塞壬不享受此减伤
		var js2 = 1 - (step - 50)/(60.0 + (step-50))
		js2 = clamp(js2, 0.45, 1)
		defR = (1 - factor/(40.0+factor)) * js2 / 0.6
		cha.addBuff(b_hurtVal_diff.new(defR))
	#基础属性加成
	if difficult >= 2 && step > 20:
		var hpl = p2 / 3000.0
		cha.attAdd.maxHpL += hpl
		if cha.isSumm:
			cha.attAdd.maxHpL *= 0.5
		cha.attAdd.atk += p1
		cha.attAdd.mgiAtk += p1
		var diffText = utils.consts.diffDic.get(difficult)
		if difficult == 7 and base.getSetting("challengeMode", false):
			diffText += "挑战"
		var tmpDef = (1 - defR * (1 - cha.attAdd.defR)) * 100
		if tmpDef > totalDef:
			totalDef = tmpDef
			azurCtrl.layertxt.bbcode_text="[color=#DC143C]当前层数：[/color]%d  [color=#DC143C]难度：[/color]%s  [color=#DC143C]当前敌方加成：[/color]血量%d%% 双攻%d 减伤%d%%" % [step, diffText, int(hpl*100), p1, totalDef]
	#实验进度加成
	if gSiren.process > 0 and difficult > 1:
		cha.attAdd.atkR += 0.01 * gSiren.process
	if gSiren.hadBoss.size() > 0:
		#boss连续加成
		if cha.get("type") == "BOSS" and cha.get("flag") == true:
			if not gSiren.sirenAwaken:
				cha.attAdd.atkR += gSiren.hadBoss.size() * 0.2
				cha.attAdd.defR += gSiren.hadBoss.size() * 0.20
				cha.attAdd.spd += gSiren.hadBoss.size() * 0.40
				cha.attAdd.suck += gSiren.hadBoss.size() * 0.1
				cha.attAdd.mgiSuck += gSiren.hadBoss.size() * 0.1
				cha.attAdd.maxHpL += gSiren.hadBoss.size() * 0.2
			else:
				cha.attAdd.atkR += gSiren.hadBoss.size() * 0.1
				cha.attAdd.defR += gSiren.hadBoss.size() * 0.20
				cha.attAdd.spd += gSiren.hadBoss.size() * 0.40
				cha.attAdd.maxHpL += gSiren.hadBoss.size() * 0.2
		cha.attAdd.defR = min(0.5, cha.attAdd.defR)
	if difficult >= 2 && step >= 60:
		#装备升级
		if cha.cell.x == 5:
			cha.addItem(sys.newItem(utils.getRandomItem("DEF")))
		var rndNum = sys.rndRan(1, 100)
		if rndNum <= itemEvoRnd * 3 and cha.items.size() < 3:
			cha.addItem(sys.newItem(utils.getRandomItem()))
			if rndNum <= itemEvoRnd and cha.items.size() < 3:
				cha.addItem(sys.newItem(utils.getRandomItem()))
		for j in cha.items:
			if sys.rndPer(itemEvoRnd):
				if j.get("upgraded") != null:
					j.upgrade()
				else:
					itemUpgrade(j)
	# if difficult >= 6 and step > 55 and cha.get("type") != "BOSS" and sys.rndPer(factor * 2):
	# 	cha.addBuff(b_legendery.new())
	if difficult == 7 and step > 81 and cha.get("type") != "BOSS" and cha.get("type") != "BOSS":
		cha.addBuff(b_shinano.new())

class b_easy:
	extends Buff
	var dispel = 2
	func _init(step = 1):
		attInit()
		id = "b_easy"
		att.def = 2 * step
		att.mgiDef = 2 * step
		att.atk = 2 * step
		att.mgiAtk = 2 * step

class b_N7:
	extends Buff
	var dispel = 2
	var p = 0.2
	func _init(p = 0.2):
		attInit()
		id = "b_N7"	
		self.p = p
		att.atkR = -p * 0.5
		att.spd = -p * 0.5
		att.cd = -p * 0.5
		att.criR = -p * 0.5
		att.atkL = -p * 0.5
		att.mgiAtkL = -p * 0.5
	func _connect():
		masCha.connect("onAtkChara",self,"run")
	func run(atkInfo):
		atkInfo.hurtVal *= (1 - p)
		
class b_shinano:
	extends Buff
	var buffName = "幽蝶之梦-AI"
	var dispel = 1
	var utils = globalData.infoDs["g_azurlineUtils"]
	var cha
	func _init(cha = null):
		attInit()
		id = "b_shinano"
		self.cha = cha
	func _connect():
		masCha.connect("onHurt", self, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 and atkInfo.hurtVal >= masCha.att.hp and masCha.get("type") != "BOSS" and sys.rndPer(30):
			utils.createSkillTextEff("幽蝶之梦", masCha.position)
			atkInfo.hurtVal = 0

class b_hurtVal_diff:
	extends Buff
	var dispel = 2
	var diff = globalData.infoDs["g_azurlineDifficult"]
	var buffUtil = globalData.infoDs["g_azurlineBuffs"]
	var num = 1.0
	var buffName = "难度加成-减伤"
	func _init(num = 1.0):
		attInit()
		id = "b_hurtVal_diff"
		self.num = num
	func _connect():
		masCha.connect("onHurt",self,"_onHurt")
	func _onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 && not atkInfo.isMiss:
			atkInfo.hurtVal *= num
	var index = 5
	# func _upS():
	# 	if diff.difficult < 6:return
	# 	index += 1
	# 	if index >= 10 and masCha.get("type") != "BOSS":
	# 		index = 0
	# 		buffUtil.addHuoLi(masCha, masCha, 5)

func itemUpgrade(item):
	item.att.maxHp *= 2
	item.att.maxHpL *= 2
	item.att.atk *= 2
	item.att.mgiAtk *= 2
	item.att.atkRan *= 2
	item.att.def *= 2
	item.att.mgiDef *= 2
	item.att.pen *= 2
	item.att.mgiPen *= 2
	item.att.cri *= 2
	item.att.criR *= 2
	item.att.suck *= 2
	item.att.mgiSuck *= 2
	item.att.spd *= 2
	item.att.dod *= 2
#召唤物难度加成
func summDiffBonus(cha):
	if step > 54 and cha.team == 2:
		doDiffBonus(cha)

func showHelp():
	var showHelp = base.getSetting("showHelp", true)
	if not showHelp:return
	var helpPop = sys.newMsg("jiangLiMsg")
	helpPop.get_node("Panel/Label").text = "新手必知"
	var panel = helpPop.get_node("Panel")
	var textBox = utils.createRichTextLabel(utils.consts.helpText, panel, Vector2(1100, 450))
	textBox.margin_left = 30
	textBox.margin_top = 50
	utils.createItemButton(panel, self, "不再显示", "noShow", [helpPop], Vector2(400, 512))
	helpPop.popup()

func noShow(helpPop):
	base.setSetting("showHelp", false)
	helpPop.hide()