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
var flag
var relic
var buffUtil
var gDiff = null
#当前触发概率
var triggerProb:int = 20
var triggerProb2:int = 10
func alInit():
	if globalData.infoDs.has("g_azurlineBase"):
		base = globalData.infoDs["g_azurlineBase"]
		path = chaData.infoDs["cazurlineA"].dir
	if base != null:
		#初始化
		utils = globalData.infoDs["g_azurlineUtils"]
		azurCtrl = globalData.infoDs["g_azurline"]
		azurCtrl.connect("onNewGame",self,"gameCtrl")
		azurCtrl.connect("resetData", self, "resetData")
		azurCtrl.connect("manualLoadGame", self, "loadData")
		azurCtrl.connect("onLoadGame",self,"loadGame")
		relic = globalData.infoDs["g_azurlineRelic"]
		buffUtil = globalData.infoDs["g_azurlineBuffs"]
		gDiff = globalData.infoDs.get("g_azurlineDifficult")

func gameCtrl():
	sys.main.connect("onBattleStart",self,"onBattleStart")
	sys.main.connect("onBattleEnd",self,"onBattleEnd")

func onBattleReady():
	if gDiff.step >= 40 and not enableHidenChas.empty() and hidenCha == null and triggerProb >= 1 and sys.rndPer(triggerProb):
		buildEvent_1()
		triggerProb = 0
	elif gDiff.step >= 30 and sys.rndPer(triggerProb2) and triggerProb2 >= 1:
		buildEvent_3()
		triggerProb2 = 0

func resetData():
	enableHidenChas = ["MarieRose", "Monica", "Honoka", "Nagisa"]
	additionSiren = 0
	window = null
	hidenCha = null
	hcFlag = false
	triggerProb = 20
	triggerProb2 = 10

func loadGame():
	loadData()
	gameCtrl()

func loadData():
	var tmp = base.getData("events", {})
	if not tmp.empty():
		enableHidenChas = tmp["enableHidenChas"]
		additionSiren = tmp["additionSiren"]
		hidenCha = tmp["hidenCha"]
		hcFlag = tmp["hcFlag"]
		triggerProb = tmp["triggerProb"]
		triggerProb2 = tmp["triggerProb2"]
func onSaveGame():
	var tmp = {}
	tmp["enableHidenChas"] = enableHidenChas
	tmp["additionSiren"] = additionSiren
	tmp["hidenCha"] = hidenCha
	tmp["hcFlag"] = hcFlag
	tmp["triggerProb"] = triggerProb
	tmp["triggerProb2"] = triggerProb2
	base.setData("events", tmp)
	relic.onSaveGame()

func onBattleStart():
	if hcFlag and hidenCha != null:
		var cha = sys.main.newChara(hidenCha.objId + "2", 1)
		sys.main.map.add_child(cha)
		cha.isSumm = true
		var cells = utils.getAllCells(2)
		for i in cells:
			if sys.main.matCha(i) == null:
				cha.setCell(i)
				break
		cha.addItem(sys.newItem(utils.getRandomItem("DEF")))
		cha.addItem(sys.newItem(utils.getRandomItem("MGI")))
		cha.addItem(sys.newItem(utils.getRandomItem("PHY")))
		cha.addBuff(buffUtil.b_kuangNu_r.new(20))
		cha.addBuff(buffUtil.b_moLi.new(20))
		cha.addBuff(buffUtil.b_atkR.new(20))
		cha.addBuff(buffUtil.b_defR.new(3))
		cha.addBuff(buffUtil.b_wudi.new(5))

func onBattleEnd():
	if hcFlag and hidenCha != null:
		buildEvent_2()

func statisChara():
	var statis = {}
	for i in utils.getAllChas(2):
		if i.get("tag") != "azurline":continue
		if i.get("type2") == "doctor":utils.dicPlus(statis, "doctor", 1)
		if i.get("type") != null:utils.dicPlus(statis, i.type, 1)
	return statis

#判断当前选项结果，1成功 2大成功 3失败
func rollResult(p):
	var rndNum = sys.rndRan(1, 100)
	if rndNum <= p * 0.35:
		return 2
	elif rndNum <= p:
		return 1
	else: 
		return 3
	# return 2
#确定按钮位置
var positionFinishBtn = Vector2(400, 500)
#选项窗口主文本大小
var sizeOptLabel = Vector2(700, 350)
func buildEventWindow():
	if is_instance_valid(window):
		window.queue_free()
	window = null
	window2 = null
	factor1 = false
	factor2 = false
	factor3 = 0
	window = utils.createWindowDialog(sys.main.get_node("ui"), "突发事件", Vector2(900, 600))
	window.popup_exclusive = true
	window.get_close_button().hide()
	var context = utils.createScrollContainer(window, Vector2(830, 550), Vector2(30, 30))
	context.name = "context"
	var vbox = utils.createVBox(context)
	vbox.name = "box"
	window.popup_centered()

func buildOptionWindow(isFinal = false, createBtn = true):
	if is_instance_valid(window2):
		window2.queue_free()
	window2 = utils.createWindowDialog(window, "事件", Vector2(900, 600))
	var context = utils.createScrollContainer(window2, Vector2(830, 450), Vector2(30, 100))
	context.name = "context"
	window2.popup_centered()
	if not createBtn:return
	if isFinal:
		utils.createItemButton(window2, self, "确定", "finishEvent", [], positionFinishBtn)
	else:
		utils.createItemButton(window2, self, "确定", "finishOption", [], positionFinishBtn)

func buildOptButton(vbox, text, callback, param):
	var hbox = utils.createHBox(vbox)
	var btn = utils.createItemButton(hbox, self, text, callback, param)
	utils.createRichTextLabel("", hbox, Vector2(500, 50))
	return btn

var window
var window2
var factor1 = false
var factor2 = false
var factor3 = 0
var hidenCha
var hcFlag:bool = false
var hidenCharas = {
	"MarieRose":{
		"objId":"cex___alhide-marierose",
		"name":"玛丽萝丝",
	},
	"Monica":{
		"objId":"cex___alhide-monica",
		"name":"莫妮卡",
	},
	"Honoka":{
		"objId":"cex___alhide-honoka",
		"name":"穗香",
	},
	"Nagisa":{
		"objId":"cex___alhide-nagisa",
		"name":"凪咲",
	},
}
var enableHidenChas = ["MarieRose", "Monica", "Honoka", "Nagisa"]
var additionSiren = 0

var btn1
var btn2
var btn3
var btn4
#==============================================救助舰娘=====================================================
func buildEvent_1():
	buildEventWindow()
	var vbox = window.get_node("context/box")
	var text = utils.createRichTextLabel("[color=#BDB76B]发现一名不知来历的舰娘，晕倒在海岸边，看起来像是刚经历了一场激烈的战斗", vbox, Vector2(700, 100))
	
	var statis = statisChara()

	factor3 = 40 + utils.dicGet(statis, "doctor", 0)  * 20
	var p2 = 40 + utils.dicGet(statis, "dd", 0) * 10
	var p4 = 20 + utils.dicGet(statis, "bb", 0) * 8

	btn1 = buildOptButton(vbox, "立刻施救", "event1_1", [])
	var dyncLabel = utils.createRichTextLabel("花费100金，当前成功率：[color=#DC143C]%d%%[/color](受治疗型角色数量影响)"%factor3, vbox, Vector2(700, 50))
	btn2 = buildOptButton(vbox, "仔细观察", "event1_2", [rollResult(p2), dyncLabel])
	utils.createRichTextLabel("当前成功率：[color=#DC143C]%d%%[/color](受驱逐舰数量影响)"%p2, vbox, Vector2(700, 50))
	btn3 = buildOptButton(vbox, "弃之不管", "event1_3", [rollResult(50)])
	utils.createRichTextLabel("当前成功率：[color=#DC143C]50%[/color]", vbox, Vector2(700, 50))
	btn4 = buildOptButton(vbox, "乘火打劫", "event1_4", [rollResult(p4)])
	utils.createRichTextLabel("当前成功率：[color=#DC143C]%d%%[/color](受战列舰数量影响)"%p4, vbox, Vector2(700, 50))

func event1_1():
	buildOptionWindow(true, false)
	var r = rollResult(factor3)
	var text = ""
	sys.main.player.plusGold(-100)
	if r == 1:
		#成功
		window2.window_title = "成功"
		utils.createItemButton(window2, self, "确定", "finishEvent", [], positionFinishBtn)
		if factor1 or sys.rndPer(60) or enableHidenChas.empty():
			var cha = sys.main.newChara(sys.rndListItem(utils.lv2))
			sys.main.player.addCha(cha)
			text = "这名舰娘终于醒了过来，她说她叫[color=#DC143C]%s[/color]，为了感激你的救命之恩，决定加入你的港区，为你战斗\n获得角色：%s"%[cha.chaName, cha.chaName]
		else:
			text = "这名舰娘是塞壬伪装的，趁我方舰娘们不注意，打伤了看护，在港区大闹了一番\n损失金币100，下场BOSS战额外刷一名普通塞壬"
			additionSiren += 1
	elif r == 2:
		#大成功
		window2.window_title = "大成功"
		utils.createItemButton(window2, self, "确定", "finishEvent", [], positionFinishBtn)
		if (factor1 or sys.rndPer(60)) and not enableHidenChas.empty():
			var key = sys.rndListItem(enableHidenChas)
			hidenCha = hidenCharas.get(key)
			enableHidenChas.erase(key)
			text = "这名舰娘终于醒了过来，她说她叫[color=#DC143C]%s[/color]，在向你道谢之后，便匆忙离开了"%hidenCha.name
		else:
			var cha = sys.main.newChara(sys.rndListItem(utils.lv3))
			sys.main.player.addCha(cha)
			text = "这名舰娘终于醒了过来，她说她叫[color=#DC143C]%s[/color]，为了感激你的救命之恩，决定加入你的港区，为你战斗\n获得角色：%s"%[cha.chaName, cha.chaName]
	else:
		#失败
		window2.window_title = "失败"
		text = "这名舰娘依然没有好转的迹象"
		utils.createItemButton(window2, self, "确定", "finishOption", [], positionFinishBtn)

	utils.createRichTextLabel(text, window2.get_node("context"), sizeOptLabel)

func event1_2(r, label):
	buildOptionWindow()
	var text = ""
	if r == 1:
		#成功
		window2.window_title = "成功"
		text = "没有发现什么可疑迹象\n施救成功率提高15%"
		factor3 += 15
		factor1 = true
	elif r == 2:
		#大成功
		window2.window_title = "大成功"
		text = "没有发现什么可疑迹象\n施救成功率提高35%"
		factor3 += 35
		factor1 = true
	else:
		#失败
		window2.window_title = "失败"
		text = "什么都没看出来"
	btn2.disabled = true
	utils.createRichTextLabel(text, window2.get_node("context"), sizeOptLabel)
	label.bbcode_text = "花费100金，当前成功率：%d%%(受治疗型角色数量影响)"%factor3

func event1_3(r):
	buildOptionWindow(true)
	var text = ""
	if r == 3:
		#失败
		window2.window_title = "失败"
		azurCtrl.plusPt(-50)
		text = "你狠心抛弃了这位落难的舰娘\nPT点数损失50点"
	else:
		#非失败
		window2.window_title = "成功"
		text = "你怀疑其中有诈，直接离开了"
	utils.createRichTextLabel(text, window2.get_node("context"), sizeOptLabel)

func event1_4(r):
	buildOptionWindow(true)
	var text = ""
	if r == 1:
		#成功
		var item = sys.newItem(itemData.rndPool.rndItem().id)
		sys.main.player.addItem(item)
		window2.window_title = "成功"
		text = "获得装备：%s"%[item.name]
	elif r == 2:
		#大成功
		var item = sys.newItem(utils.getRandomItem("RARE"))
		sys.main.player.addItem(item)
		window2.window_title = "大成功"
		text = "获得装备：%s"%[item.name]
	else:
		#失败
		window2.window_title = "失败"
		text = "一无所获\nPT点数损失50点"
		azurCtrl.plusPt(-50)
	utils.createRichTextLabel(text, window2.get_node("context"), sizeOptLabel)

func finishOption():
	window2.hide()

func finishEvent():
	if is_instance_valid(window2):
		window2.hide()
	window.hide()
	window.queue_free()

#==============================================隐藏舰娘来投=====================================================
func buildEvent_2():
	buildEventWindow()
	var cha = sys.main.newChara(hidenCha.objId)
	sys.main.player.addCha(cha)
	var text = utils.createRichTextLabel("[color=#BDB76B]在战斗最激烈的关键时刻，%s从敌舰队后方突然杀出，'让我来助你一臂之力吧，指挥官！'[/color]\n获得角色：[color=#DC143C]%s"%[hidenCha.name, cha.chaName], window.get_node("context"), sizeOptLabel)
	utils.createItemButton(window, self, "确定", "finishEvent", [], positionFinishBtn)
	hidenCha = null
	hcFlag = false

#==============================================游荡舰队=====================================================
func buildEvent_3():
	buildEventWindow()
	var vbox = window.get_node("context/box")
	var text = utils.createRichTextLabel("[color=#BDB76B]指挥官，雷达探测到前方海域有大量活动信号，身份不明", vbox, Vector2(700, 100))
	
	var statis = statisChara()

	var p1 = 50 + utils.dicGet(statis, "cv", 0) * 14
	var p2 = 50 + utils.dicGet(statis, "cl", 0) * 14
	var p3 = 50 + utils.dicGet(statis, "ca", 0) * 14

	btn1 = buildOptButton(vbox, "主动联络", "event3_1", [rollResult(p1)])
	utils.createRichTextLabel("当前成功率：[color=#DC143C]%d%%[/color](受航母舰娘数量影响)"%p1, vbox, Vector2(700, 50))
	btn2 = buildOptButton(vbox, "紧急规避", "event3_2", [rollResult(p2)])
	utils.createRichTextLabel("当前成功率：[color=#DC143C]%d%%[/color](受轻巡舰娘数量影响)"%p2, vbox, Vector2(700, 50))
	btn3 = buildOptButton(vbox, "直接攻击", "event3_3", [rollResult(p3)])
	utils.createRichTextLabel("当前成功率：[color=#DC143C]%d%%[/color](受重巡舰娘数量影响)"%p3, vbox, Vector2(700, 50))

func event3_1(r):
	buildOptionWindow(true)
	var text = ""
	if r == 1:
		#成功
		window2.window_title = "成功"
		var item = sys.newItem(itemData.rndPool.rndItem().id)
		sys.main.player.addItem(item)
		text = "'这里是皇家海军分遣舰队，感谢你们一直以来做出的贡献，这是我们的一点心意，希望能够帮到你们！'\n获得装备：%s"%[item.name]
	elif r == 2:
		#大成功
		window2.window_title = "大成功"
		var cha = sys.main.newChara(sys.rndListItem(utils.lv3))
		sys.main.player.addCha(cha)
		text = "'这里是皇家海军分遣舰队，感谢你们一直以来做出的贡献，我们决定派人协助你们作战'\n获得角色：%s"%[cha.chaName]
	else:
		#失败
		window2.window_title = "失败"
		text = "是塞壬的信号！你的主动联动暴露了位置，塞壬主动向你发起了进攻\n下场BOSS战额外刷一名普通塞壬"
		additionSiren += 1

	utils.createRichTextLabel(text, window2.get_node("context"), sizeOptLabel)

func event3_2(r):
	buildOptionWindow(true)
	var text = ""
	if r == 1:
		#成功
		window2.window_title = "成功"
		text = "规避成功"
	elif r == 2:
		#大成功
		window2.window_title = "大成功"
		text = "规避成功"
	else:
		#失败
		window2.window_title = "失败"
		text = "规避失败！你暴露了舰队位置，塞壬主动向你发起了进攻\n下场BOSS战额外刷一名普通塞壬"
		additionSiren += 1
	utils.createRichTextLabel(text, window2.get_node("context"), sizeOptLabel)

func event3_3(r):
	buildOptionWindow(true)
	var text = ""
	if r == 1:
		#成功
		window2.window_title = "成功"
		var item = sys.newItem(itemData.rndPool.rndItem().id)
		sys.main.player.addItem(item)
		azurCtrl.plusPt(-50)
		text = "你攻击了重樱巡逻舰队\n获得装备：%s，损失PT点数50"%[item.name]
	elif r == 2:
		#大成功
		window2.window_title = "大成功"
		var item = sys.newItem(utils.getRandomItem("RARE"))
		sys.main.player.addItem(item)
		text = "你击败了塞壬舰队\n获得装备：%s"%[item.name]
	else:
		#失败
		window2.window_title = "失败"
		text = "战斗陷入胶着，越来越多的塞壬赶来支援\n下场BOSS战额外刷一名普通塞壬"
		additionSiren += 1
	utils.createRichTextLabel(text, window2.get_node("context"), sizeOptLabel)