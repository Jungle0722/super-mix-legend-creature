extends Node
var base = null
var utils
var azurCtrl
var diff
var window
var uploadCount = 0
var teamWindow
var teamContext
var skillPool
func _ready():
	pass
func _init():
	call_deferred("azurlineInit")
	pass
func _connect():
	pass

func azurlineInit():
	if globalData.infoDs.has("g_azurlineBase"):
		base = globalData.infoDs["g_azurlineBase"]
	if base != null:
		#初始化
		base.connect("onNewGame",self,"newGame")
		utils = globalData.infoDs["g_azurlineUtils"]
		skillPool = globalData.infoDs["g_azurlineSkills"]
		diff = globalData.infoDs["g_azurlineDifficult"]
		azurCtrl = globalData.infoDs["g_azurline"]
		azurCtrl.connect("resetData", self, "resetData")
		azurCtrl.connect("onLoadGame",self,"loadGame")
		
func resetData():
	window = null
	teamWindow = null
	teamContext = null
	rankDataCache = {}
	uploadCount = 0
	teamDataCache = {}

func loadGame():
	gameCtrl()

func newGame():
	gameCtrl()

func gameCtrl():
	sys.main.connect("onTongGuan", self, "afterTongGuan")
	sys.main.connect("onBattleEnd", self, "onBattleEnd")
	
func afterTongGuan(x):
	#无尽通关上传阵容
	upload(diff.step)
		# achievement()

func onBattleEnd():
	var step = diff.step
	if step == 81:
		#81关上传阵容
		upload(step)

func upload(step):
	if not azurCtrl.allAzurlineFlag || uploadCount > 1 && step <= 161 || uploadCount > 2 && step > 161:return
	print("上传当前阵容")
	uploadCount += 1
	var diff = base.getSetting("difficult2", 1)
	var body = {"userName": utils.getPlayerName(), "difficult":diff, "level":step, "charas":{"values":[], "talents":[]}, "weight":0, "steamId": utils.getPlayerId()}
	var weight = 0
	for i in sys.main.btChas:
		if i.team == 1:
			if i.get("tag") != "azurline":
				return
			var chaDic = {}
			if i.lv != 4:continue
			chaDic["chaId"] = i.id
			chaDic["chaName"] = i.chaName
			var items = []
			for j in i.items:
				items.append(j.id)
			chaDic["items"] = items
			chaDic["cell"] = i.oldCell
			chaDic["skId"] = ""
			chaDic["skLv"] = 0
			chaDic["level"] = i.get("level")
			if i.get("skillSlot") != null:
				chaDic["skId"] = i.skillSlot.sid
				chaDic["skLv"] = i.skillSlot.rarity
			if i.get("rank") != null:
				chaDic["rank"] = i.rank
				chaDic["rndAttSel"] = i.rndAttSel
				for j in i.skillSlots.keys():
					var s = i.skillSlots.get(j)
					if s != null:
						chaDic["cmdSk%d"%j] = s.sid
				if i.cmdSkill != null:
					chaDic["cmdSkill"] = i.cmdSkill.sid				
			body.charas.values.append(chaDic)
			weight += i.lv
	body["weight"] = weight
	if base.getSetting("specialFleet2", false):
		var types = utils.checkCharaType()
		var num = 0
		var validNum = 0
		for i in types.values():
			if i > 0:
				validNum += 1
			num += i
		
		if validNum <= 2 and validNum > 0:
			var tag = "tz:"
			for i in types.keys():
				if types.get(i) > 0:
					tag += utils.consts.shipType.get(i) + "-"
			tag = tag.substr(0, tag.length() - 1)
			body["tag"] = tag

	for i in sys.main.player.talentDs.values():
		body.charas.talents.append(i.id)

	var res = azurCtrl.net.sendRequest("/azurline/team/submit", HTTPClient.METHOD_POST, to_json(body))
	res = JSON.parse(res).result
	if res.code == "success":
		print("上传成功!")
	
#创建排行榜
func buildRankList(node):
	utils.createItemButton(node, self, "排行榜", "openRankList", [])

	window = utils.createWindowDialog(sys.main.get_node("ui"), "碧蓝航线排行榜", Vector2(900, 700))

	teamWindow = utils.createWindowDialog(window, "玩家阵容", Vector2(800, 700))
	teamWindow.hide()

	var tab = TabContainer.new()
	tab.name = "tab"
	tab.margin_left = 40
	tab.margin_top = 20
	window.add_child(tab)
	tab.connect("tab_selected", self, "switchMode")
	for i in ["标准模式", "特种模式"]:
		var contentScroll = utils.createScrollContainer(tab, Vector2(820, 600), Vector2(30, 30))
		contentScroll.name = i

		var totalContainer = utils.createVBox(contentScroll, Vector2(30, 30))
		totalContainer.name = "total"
		
		if i == "特种模式":
			var hbox = utils.createHBox(totalContainer, Vector2(30, 30))
			utils.createLabel("(单舰种则选择两个同样种族)种族1：", hbox)
			var optBtn1 = OptionButton.new()
			optBtn1.add_item("驱逐")
			optBtn1.add_item("轻巡")
			optBtn1.add_item("重巡")
			optBtn1.add_item("战列")
			optBtn1.add_item("航母")
			optBtn1.add_item("辅助")
			hbox.add_child(optBtn1)

			utils.createLabel("  种族2：", hbox)
			var optBtn2 = OptionButton.new()
			optBtn2.add_item("驱逐")
			optBtn2.add_item("轻巡")
			optBtn2.add_item("重巡")
			optBtn2.add_item("战列")
			optBtn2.add_item("航母")
			optBtn2.add_item("辅助")
			hbox.add_child(optBtn2)

			optBtn1.select(0)
			optBtn2.select(0)

			utils.createItemButton(hbox, self, "确定", "queryTzMode", [optBtn1, optBtn2])

		var statisContainer = utils.createVBox(totalContainer, Vector2(30, 100))
		statisContainer.name = "vbox"

	var statisScroll = utils.createScrollContainer(teamWindow, Vector2(600, 600), Vector2(30, 30))
	teamContext = utils.createVBox(statisScroll, Vector2(30, 30))

func switchMode(index):
	var tab = window.get_node("tab")
	var container = tab.get_current_tab_control()
	var vbox = container.get_node("total/vbox")
	match container.name:
		"标准模式":loadData("normal", vbox)
		# "专家模式":loadData("zj", vbox)
		"特种模式":pass
			
func queryTzMode(optBtn1, optBtn2):
	var tab = window.get_node("tab")
	var container = tab.get_current_tab_control()
	var vbox = container.get_node("total/vbox")
	var shipTypes = []
	var type = optBtn1.get_item_text(optBtn1.get_selected())
	shipTypes.append(type)

	type = optBtn1.get_item_text(optBtn2.get_selected())
	if not shipTypes.has(type):
		shipTypes.append(type)
		shipTypes.sort_custom(utils, "sortByShipType")
	
	var tag = "tz:"
	for i in shipTypes:
		tag += utils.consts.shipType.get(i) + "-"
	tag = tag.substr(0, tag.length() - 1)
	loadData(tag, vbox)

var rankDataCache = {}
var teamDataCache = {}
func loadData(tag, statisContainer):
	for i in statisContainer.get_children():
		i.queue_free()
	if not rankDataCache.has(tag):
		var res = azurCtrl.net.sendRequest("/azurline/rankList?tag=%s"%tag, HTTPClient.METHOD_GET)
		if res == null:
			print("无返回数据")
			return
		res = parse_json(res)
		rankDataCache[tag] = res.data
	var cache = utils.dicGet(rankDataCache, tag, [])
	for i in range(cache.size()):
		var vo = cache[i]
		var hbox = HBoxContainer.new()
		utils.createRichTextLabel("#{0}      [color=#FFA500]{1}[/color]".format({"0":i+1, "1":vo.userName}), hbox, Vector2(350, 50))
		utils.createRichTextLabel("[color=#C0C0C0]{2}[/color]".format({"2":vo.createTime}), hbox, Vector2(230, 50))
		utils.createRichTextLabel("难度：{diff}".format({"diff":utils.consts.diffDic.get(int(vo.difficult))}), hbox, Vector2(150, 50))
		utils.createItemButton(hbox, self, "查看", "loadTeamInfo", [vo.id], Vector2(0, 0))
		statisContainer.add_child(hbox)

#打开排行榜
func openRankList():
	window.popup_centered()

#加载玩家阵容
func loadTeamInfo(id):
	for i in teamContext.get_children():
		i.queue_free()
	var data = teamDataCache.get(id)
	if data == null:
		var res = azurCtrl.net.sendRequest("/azurline/team/get?teamId=%d"%id, HTTPClient.METHOD_GET)
		if res == null:
			print("无返回数据")
			return
		res = parse_json(res)
		data = res.data.charas
		data = parse_json(data).values
		teamDataCache[id] = data
	for vo in data:
		utils.createRichTextLabel(vo.chaName, teamContext)
	teamWindow.popup_centered()
