extends Node
func _ready():
	pass
func _init():
	call_deferred("alInit")
func _connect():
	pass
var utils = null
var azurCtrl = null
var base = null
var path = null
var pvp
var relic
var difficult
var event2
func alInit():
	if globalData.infoDs.has("g_azurlineBase"):
		base = globalData.infoDs["g_azurlineBase"]
		path = chaData.infoDs["cazurlineA"].dir
	if base != null:
		#初始化
		utils = globalData.infoDs["g_azurlineUtils"]
		pvp = globalData.infoDs["g_azurlinePVP"]
		azurCtrl = globalData.infoDs["g_azurline"]
		azurCtrl.connect("resetData", self, "resetData")
		base.connect("onStartGame",self,"onStartGame")
		relic = globalData.infoDs["g_azurlineRelic"]
		difficult = globalData.infoDs["g_azurlineDifficult"]
		event2 = globalData.infoDs["g_azurlineEventsNew"]
		azurCtrl.connect("onLoadGame",self,"loadGame")
		azurCtrl.connect("manualLoadGame", self, "loadGame")

func onSaveGame():
	var tmp = {}
	tmp["tongGuanCount"] = tongGuanCount
	tmp["process"] = process
	tmp["hadBoss"] = hadBoss
	tmp["bossConfig"] = bossConfig
	tmp["activate"] = activate
	tmp["bonusConfig"] = bonusConfig
	tmp["bonus"] = bonus
	tmp["ticket"] = ticket
	tmp["ticketProcess"] = ticketProcess
	tmp["reConfig"] = reConfig
	tmp["reIndex"] = reIndex
	tmp["sirenAwaken"] = sirenAwaken
	tmp["darkFood"] = darkFood

	tmp["bossOpts"] = bossOpts

	base.setData("siren", tmp)
	base.saveData()
func loadGame():
	var tmp = base.getData("siren", {})
	if not tmp.empty():
		tongGuanCount = tmp["tongGuanCount"]
		process = tmp["process"]
		hadBoss = tmp["hadBoss"]
		bossConfig = tmp["bossConfig"]
		activate = tmp["activate"]

		bonus = tmp["bonus"]
		ticket = tmp["ticket"]
		ticketProcess = tmp["ticketProcess"]
		reConfig = tmp["reConfig"]
		reIndex = tmp["reIndex"]
		bonusConfig = tmp["bonusConfig"]
		sirenAwaken = tmp["sirenAwaken"]
		darkFood = tmp["darkFood"]

		bossOpts = tmp["bossOpts"]


func onStartGame():
	sys.main.connect("onBattleEnd", self, "onBattleEnd")
	sys.main.connect("onBattleStart",self,"onBattleStart")
	sys.main.connect("onTongGuan", self, "afterTongGuan")
	bossIds = []
	for value in bossConfig.values():
		bossIds.append(value.objId)

	if not is_instance_valid(window) or not window is WindowDialog:
		createChallenge()

var tongGuanCount = 0
func afterTongGuan(x):
	tongGuanCount += 1

var process = 0
var hadBoss = []
#塞壬觉醒
var sirenAwaken:bool = false
#黑暗料理
var darkFood:bool = false

signal challengeSuccess
func challengeSuccess(id, giftCha):
	currentBoss = null
	activate = false
	process = max(0, process-30)
	refreshProcess()
	hadBoss.append({"id":giftCha.id, "cha":giftCha})
	emit_signal("challengeSuccess")

func challengeFail():
	currentBoss = null
	activate = false
	sys.newBaseMsg("重要提示", "挑战失败！")
var ticketProcess = 0
func onBattleEnd():
	ticketProcess += 1
	if sirenAwaken:
		ticketProcess += 1
		if sys.rndPer(35):
			ticketProcess += 1
	if step > 50:
		process += 1
		refreshProcess()
	if step > 81 and sys.rndPer(50):
		ticketProcess += 1

	if ticketProcess >= 17 && step < 160:
		ticketProcess = 0
		ticket += 1
		ticket += relic.sirenTicketBonus
		refreshTicket()

func resetData():
	tongGuanCount = 0
	ticket = 0
	currentBoss = null
	activate = false
	bonus = []
	hadBoss = []
	ticketProcess = 0
	sirenAwaken = false
	window = null
	context = null
	ticketLabel = null
	helpWindow = null
	bonusWindow = null
	bonusBox = null
	darkFood = false
	reConfig = {"lv1":20,"lv2":0,"lv3":0}
	reIndex = -1
	fuLiGuanFlag = false
	bossOpts.clear()

	for i in bossConfig.values():
		i.enable = true
	for i in bonusConfig.values():
		i.enable = true

var leaders = ["cex___siren-explorer%d", "cex___siren-hunter%d", "cex___siren-chess%d", "cex___siren-breaker%d", "cex___siren-seaLeader%d"]
var step = 0
var fuLiGuanFlag = false
func doSiren():
	step = sys.main.guankaMsg.lvStep - 2
	if sys.main.batType != 2 and tongGuanCount == 0 and sys.rndRan(1, 1000) == 99 and step >= 30 and step <=  70:
		fuLiGuanFlag = true
		fuLiGuan()
		return
	fuLiGuanFlag = false
	if step == 15:
		createTransportShip()
	if step > 20 && currentBoss == null and step < 161 and sys.main.batType != 2:
		if sys.rndPer(12):
			#刷物资船
			createTransportShip()
		elif sys.rndPer(15+step/2):
			#开始刷头目
			var rnd = sys.rndRan(0, leaders.size()-1)
			if step > 50:
				#3级头目
				createBoss(sys.rndListItem(leaders)%[3])
			elif step > 30:
				#2级头目
				createBoss(sys.rndListItem(leaders)%[2])
			else:
				#1级头目
				createBoss(sys.rndListItem(leaders)%[1])
	if sys.main.batType == 2 and tongGuanCount == 0:
		if sys.main.batLLv == 0:
			checkUserName()
			#boss lv1 27关 创建两个2级头目
			createBoss(sys.rndListItem(leaders)%[2])
		if sys.main.batLLv == 1:
			#boss lv2 54关
			clearHalf()
			createBoss("cex___siren-builder", false)
		if sys.main.batLLv == 2:
			#boss lv3 81关
			clearHalf()
			createBoss("cex___siren-cleaner", false)
			createBoss(sys.rndListItem(leaders)%[3])
			createBoss(sys.rndListItem(leaders)%[3])
		if sys.main.batLLv == 3:
			#boss lv4 108关
			clearHalf()
			createBoss("cex___siren-strength", false)
			createBoss(sys.rndListItem(leaders)%[3])
			createBoss(sys.rndListItem(leaders)%[3])
			createBoss(sys.rndListItem(leaders)%[3])
			createBoss(sys.rndListItem(leaders)%[3])
		if sys.main.batLLv == 4:
			#boss lv5 135关
			createBoss("cex___siren-hermit", false)
			createBoss(sys.rndListItem(leaders)%[3])
			createBoss(sys.rndListItem(leaders)%[3])
			createBoss(sys.rndListItem(leaders)%[3])
			createBoss(sys.rndListItem(leaders)%[3])
		if sys.main.batLLv == 5:
			#boss lv6 161关
			if sys.rndPer(50):
				createBoss("cex___siren-empres", false)
			else:
				createBoss("cex___siren-temparans", false)
			if difficult.difficult > 3:
				var n = difficult.difficult - 1
				clearNum(n - 3)
				for i in range(n):
					createBoss((leaders[i])%[3])

		checkEvent()
	
	if currentBoss != null and sys.main.batType != 2:
		activate = true
		clearHalf()
		createBoss(currentBoss.objId)
#检查随机事件相关逻辑
func checkEvent():
	if event2.additionSiren > 0:
		for i in range(event2.additionSiren):
			if step > 80:
				createBoss(sys.rndListItem(leaders)%[3])
			elif step > 60:
				createBoss(sys.rndListItem(leaders)%[2])
			else:
				createBoss(sys.rndListItem(leaders)%[1])
		event2.additionSiren = 0		
	if event2.hcFlag == false and event2.hidenCha != null:
		event2.hcFlag = true
#福利关
func fuLiGuan():
	sys.newBaseMsg("稀有事件", "指挥官，前方发现一支塞壬运输船队！")
	for i in getAllEnemys():
		sys.main.delMatChara(i)
		var cha = createTransportShip()
		cha.attAdd.maxHpL += 1
		cha.attAdd.def += 200
		cha.attAdd.mgiDef += 200
		cha.attAdd.defR += 0.3
		cha.upAtt()
#创建运输船
func createTransportShip():
	if step < 70:
		return createBoss("cex___siren-material")
	else:
		return createBoss("cex___siren-material2")

#真无尽刷怪逻辑
var reConfig = {"lv1":20,"lv2":0,"lv3":0}
var reIndex = -1
var reCell = Vector2(5, -1)
var reChas = []
func realEndless():
	clearAll()
	azurCtrl.plusPt(150)
	sys.main.player.plusGold(150)
	if step > 166:
		if reIndex >= 0 and reIndex < 4:
			if reConfig.lv1 > 0:
				reConfig.lv2 += 1
				reConfig.lv1 -= 1
			reIndex += 1
		elif reIndex >= 4 and reConfig.lv3 < 20:
			reIndex = 0
			reConfig.lv3 += 1
			if reConfig.lv1 > 0:
				reConfig.lv1 -= 1
			elif reConfig.lv2 > 0:
				reConfig.lv2 -= 1
		else:
			reIndex += 1
	reCell = Vector2(5, -1)
	reChas = []
	if reConfig.lv1 > 0:
		for i in range(reConfig.lv1):
			createChaForRE(sys.rndListItem(utils.lv4))
	if reConfig.lv2 > 0:
		for i in range(reConfig.lv2):
			createChaForRE(sys.rndListItem(leaders)%[3])
	if reConfig.lv3 > 0:
		for i in range(reConfig.lv3):
			createChaForRE(sys.rndListItem(bossIds))
			
	for cha in reChas:
		cha.addItem(sys.newItem(utils.getRandomItem("DEF")))
		cha.addItem(sys.newItem(utils.getRandomItem("MGI")))
		cha.addItem(sys.newItem(utils.getRandomItem("PHY")))
	
#敌方全场铺满时会导致死循环
func createChaForRE(id):
	reCell += Vector2(0, 1)
	if reCell.y > 5:
		reCell.y = 0
		reCell.x += 1
	var cha = sys.main.newChara(id, 2)
	reChas.append(cha)
	sys.main.map.add_child(cha)
	sys.main.setMatCha(reCell, cha)
	yield(sys.get_tree().create_timer(0.02), "timeout")
	if cha.get("type") == "BOSS":
		cha.delFlag = false
		cha.flag = false

var last = [Vector2(8,1), Vector2(8,2), Vector2(8,3), Vector2(9,1), Vector2(9,2), Vector2(9,3), Vector2(7,1), Vector2(7,2), Vector2(7,3), Vector2(6,1), Vector2(6,2), Vector2(6,3)]
func createBoss(id, gift = true):
	var cha = null
	last.shuffle()
	for cell in last:
		if sys.main.matCha(cell) == null:
			cha = sys.main.newChara(id, 2)
			sys.main.map.add_child(cha)
			sys.main.setMatCha(cell, cha)
			break
	if cha == null:
		for cell in last:
			var matcha = sys.main.matCha(cell)
			if matcha != null && matcha.get("type") != "BOSS":
				sys.main.delMatChara(matcha)
				cha = sys.main.newChara(id, 2)
				sys.main.map.add_child(cha)
				sys.main.setMatCha(cell, cha)
				break
	if cha != null && not gift:
		cha.delFlag = false
		cha.flag = false
	return cha
	
func clearAll():
	for i in getAllEnemys():
		sys.main.delMatChara(i)

func clearHalf():
	var chas =  getAllEnemys()
	chas.sort_custom(self, "sortByLv")
	for i in range(chas.size()/2):
		if i >= chas.size():break
		sys.main.delMatChara(chas[i])

func clearNum(num:int):
	var chas = getAllEnemys()
	chas.sort_custom(self, "sortByLv")
	for i in range(num):
		if i >= chas.size():break
		sys.main.delMatChara(chas[i])

func getAllEnemys():
	var chas = []
	for i in utils.getAllCells(2):
		var cha = sys.main.matCha(i)
		if cha!=null && cha.team != 1 && cha.get("type") != "BOSS": 
			chas.append(cha)
	return chas

var window
var context
var ticketLabel
var helpWindow
var processLabel
#挑战券
var ticket = 0
#BOSS配置表
var bossConfig = {
	"侵扰者":{
		"objId":"cex___siren-intruder",
		"enable":true
	},
	"侵扰者Ⅲ型":{
		"objId":"cex___siren-intruder3",
		"enable":true
	},
	"净化者":{
		"objId":"cex___siren-purifier",
		"enable":true
	},
	"测试者α型":{
		"objId":"cex___siren-tester",
		"enable":true
	},
	"测试者β型":{
		"objId":"cex___siren-tester2",
		"enable":true
	},
	"织梦者":{
		"objId":"cex___siren-weaveDream",
		"enable":true
	},
	"代行者·III":{
		"objId":"cex___siren-executer-a",
		"enable":true
	},
	"代行者·VIII":{
		"objId":"cex___siren-executer-b",
		"enable":true
	},
	"代行者·IX":{
		"objId":"cex___siren-executer-c",
		"enable":true
	},
	"代行者·XIV":{
		"objId":"cex___siren-executer-d",
		"enable":true
	},
	"烬舰队·高雄":{
		"objId":"cex___siren-gaoxiong",
		"enable":true
	},
	"烬舰队·企业":{
		"objId":"cex___siren-qiye",
		"enable":true
	},
	"烬舰队·飞龙":{
		"objId":"cex___siren-feilong",
		"enable":true
	},
	"烬舰队·皇家方舟":{
		"objId":"cex___siren-fangzhou",
		"enable":true
	},
}
var bossIds = []
func openChallenge():
	if not is_instance_valid(window) or not window is WindowDialog:
		createChallenge()
	refreshUi()	
	refreshTicket()
	window.popup_centered()
var windowSize = Vector2(600, 500)
func createChallenge():
	window = utils.createWindowDialog(sys.main.get_node("ui"), "挑战系统", windowSize)
	context = utils.createScrollContainer(window, Vector2(500, 450), Vector2(30, 120))

	var hbox = utils.createHBox(window)
	hbox.rect_position = Vector2(50, 40)
	ticketLabel = utils.createRichTextLabel("挑战券:%d"%ticket, hbox, Vector2(150, 50))
	processLabel = utils.createRichTextLabel("当前实验进度:%d"%process, hbox, Vector2(180, 50))
	# utils.createRichTextLabel("数据解析:%d"%process, hbox, Vector2(180, 50))


	var hbox2 = utils.createHBox(window)
	hbox2.rect_position = Vector2(50, 400)
	var btn = utils.createItemButton(hbox2, self, "帮助说明", "loadHelp")
	# btn.rect_position = Vector2(400, 30)
	var btn2 = utils.createItemButton(hbox2, self, "兑换增益", "loadBonus")
	# btn2.rect_position = Vector2(500, 30)

	var btn3 = utils.createItemButton(window, self, "挑战", "initOpts")
	btn3.rect_position = Vector2(250, 230)
	btn3.name = "btn3"
	createBonusUI()

func refreshUi():
	if currentBoss == null and not bossOpts.empty() and (not window.has_node("opts") or not is_instance_valid(window.get_node("opts"))):
		buildOpts()

func initOpts():
	if currentBoss != null:
		sys.newBaseMsg("提示", "请勿重复选择挑战对象！")
		return
	buildOpts()	

func buildOpts():		
	window.get_node("btn3").hide()
	var arrs = []
	for key in bossConfig.keys():
		var conf = bossConfig.get(key)
		if conf.enable:arrs.append(key)
	arrs.shuffle()		
	bossOpts.clear()
	for i in range(3):
		if i >= arrs.size():break
		bossOpts.append(arrs[i])

	var hbox = utils.createHBox(window)
	hbox.name = "opts"
	hbox.rect_position = Vector2(50, 150)

	for i in bossOpts:
		var conf = bossConfig.get(i)
		# var itemPanel = Panel.new()
		# itemPanel.name = "panel"
		# itemPanel.rect_min_size = Vector2(250, 250)
		# itemPanel.theme = null

		var vbox = utils.createVBox(hbox)

		# hbox.add_child(itemPanel)
		var chaBt = utils.newChaBt(vbox, conf.objId)
		utils.createItemButton(vbox, self, "   选择   ", "doChallenge", [i, conf], Vector2(100, 180))
		var chara = chaBt.get_child(0)
		var ui = chara.get_child(3)
		var chaName = ui.get_node("chaName")
		chaName.text = chaName.text.replace("「神秘」", "").replace("「高级塞壬」", "")

func refreshTicket():
	if not azurCtrl.allAzurlineFlag:return
	ticketLabel.text = "挑战券:%d"%ticket

func refreshProcess():
	if is_instance_valid(processLabel):
		processLabel.text = "当前实验进度:%d"%process

var helpText = """
[color=#BDB76B]塞壬挑战:[/color]
点击BOSS后面的挑战按钮，消耗1张挑战券对该BOSS发起挑战，下一次选关后，将会刷出该BOSS
每位BOSS一局只能挑战一次
挑战失败不会结束游戏
[color=#BDB76B]实验进度:[/color]
塞壬的秘密实验，40层开始每回合结束时，都会提高实验进度，每级进度使电脑造成的伤害增加1%
挑战成功后，可以降低30层实验进度
[color=#BDB76B]塞壬捕获:[/color]
BOSS被击败后，玩家会获得该BOSS的心智残缺体（即BOSS的青春版）
可以通过不断的战斗来提升战斗等级，变得更强
[color=#BDB76B]挑战券:[/color]
每20层掉落一张，不仅可以开启BOSS战，还可以用来获得增益、提高奖励等等
[color=#BDB76B]排行榜（未实装）:[/color]
玩家可以查看每个BOSS的挑战排行榜，根据挑战的最低层数排行
"""
func loadHelp():
	utils.openHelpWindow(helpText)

var bonusWindow
var bonus = []
var bonusBox
func loadBonus():
	buildBonus()
	bonusWindow.popup_centered()

func createBonusUI():
	bonusWindow = utils.createWindowDialog(sys.main.get_node("ui"), "兑换增益", Vector2(600, 600))
	bonusBox = VBoxContainer.new()
	bonusBox.margin_top = 50
	bonusBox.margin_left = 50
	bonusWindow.add_child(bonusBox)

func buildBonus():
	for i in bonusBox.get_children():
		i.queue_free()
	for key in bonusConfig.keys():
		var conf = bonusConfig.get(key)
		if not conf.enable:continue
		var hbox = utils.createHBox(bonusBox)
		utils.createRichTextLabel(utils.consts.colorGold + conf.text, hbox, Vector2(400, 50))
		utils.createItemButton(hbox, self, "选择", "selBonus", [key, conf])

func selBonus(key, conf):
	if ticket == 0:
		sys.newBaseMsg("提示", "挑战券不足，无法获得增益！")
		return
	bonus.append(key)
	bonusConfig.get(key).enable = false
	ticket -= 1
	refreshTicket()
	buildBonus()

var bonusConfig = {
	"atk":{"text":"本局之内挑战BOSS时，提高30%双攻", "enable":true},
	"spd":{"text":"本局之内挑战BOSS时，提高50%攻速", "enable":true},
	"cd":{"text":"本局之内挑战BOSS时，提高40%冷却缩减", "enable":true},
	"cri":{"text":"本局之内挑战BOSS时，提高50%暴击", "enable":true},
	"pen":{"text":"本局之内挑战BOSS时，提高30%双穿", "enable":true},
}

func onBattleStart():
	if not activate or bonus.empty() or difficult.difficult == 1:return
	for i in utils.getAllChas(2):
		if bonus.has("atk"):
			i.addBuff(utils.buffs.b_atkL.new(3))
			i.addBuff(utils.buffs.b_mgiAtkL.new(3))
		if bonus.has("spd"):
			i.addBuff(utils.buffs.b_spd.new(5))
		if bonus.has("cd"):
			i.addBuff(utils.buffs.b_cd.new(4))
		if bonus.has("cri"):
			i.addBuff(utils.buffs.b_cri.new(5))
		if bonus.has("pen"):
			i.addBuff(utils.buffs.b_twoPenL.new(3))

var currentBoss
var activate = false
var bossOpts = []
func doChallenge(name, conf):
	if ticket <= 0:
		sys.newBaseMsg("提示", "挑战券不足，无法挑战！")
		return
	ticket -= 1
	refreshTicket()
	bossConfig.get(name).enable = false
	currentBoss = conf
	refreshUi()
	window.get_node("opts").queue_free()
	window.get_node("btn3").show()

func checkUserName():
	var userName = base.getSetting("userName")
	if utils.osName == "Android" and (userName == null or userName == "未知安卓玩家"):
		var window = utils.createWindowDialog(sys.main.get_node("ui"), "输入用户名", Vector2(750, 350))
		var vbox = utils.createVBox(window)
		vbox.rect_position = Vector2(50, 50)
		vbox.name = "vbox"
		utils.createRichTextLabel(utils.consts.colorGold + "请输入用户名，通关后将以该名称计入排行榜", vbox, Vector2(650, 120))
		var le = LineEdit.new()
		le.max_length = 24
		le.name = "le"
		vbox.add_child(le)
		utils.createItemButton(window, self, "确定", "doChangeName", [le, window], Vector2(210, 250))
		window.popup_exclusive = true
		window.get_close_button().hide()
		window.popup_centered()

func doChangeName(le, window):
	if le.text.length() == 0:
		return
	base.setSetting("userName", le.text)
	window.hide()
	window.queue_free()
