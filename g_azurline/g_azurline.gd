extends Node
var base = null
var data = []
var path = null
var switchBtn = null
var bgBtn = null
var utils = null
var layertxt
var uiFlag = false
var allAzurlineFlag = true
var gshop = null
var gDiff = null
var gSiren = null
var gResearch = null
var settingPanel = null
var omg
var achieve
var pvp
var net
var gllustrate
var gllustrate2
var itemIllus
var gEvent
var gEvent2
var relic
var gTalents
#机组进阶训练
var crewTraining:bool = false
#当前Up角色
var upCha = null
#当前Up角色名称
var upChaName = "无"
#本局彩票购买数量
var buyLotteryNum:int = 0
var miuChas = []
#本局评论次数
var commentNum:int = 0
var checkedVersion = false

var selectedBonus = []
var selectedTactialSup = null
var tactialSupportLv:int = 1
var tactialSupportExp:int = 0
var tactialSupportCd:int = 4
#炮术专精
var gunMaster = null
#医术专精
var healHpL:float = 0
#护盾专精
var shieldBonus:float = 0
#μ兵装计划
var miuProject:int = 0
#圣盾缓冲
var holyShield:bool = false
#强制舰种转换
var convertShipType = {}
#指挥官进阶训练
var commanderTraining:bool = false
#圣盾硬化
var holyShieldRein:bool = false
#魔武专精
var apadMaster = null
#阵营特化
var campMaster = []
#额外人口天赋
var addiPop:int = 0
#全明星阵容天赋 
var allStar:bool = false
#破败王者天赋
var failKing:bool = false
#战败保护次数
var failProtect:int = 0
#全局装备槽上限
var globalItemSlot:int = 0

signal resetData
signal initMainUI
signal onBattleReady
signal buyLottery
signal onLoadGame
signal onNewGame
signal manualLoadGame
func _ready():
	pass
func _init():
	call_deferred("azurlineInit")
	print("碧蓝航线海军总部:已就绪")
func _connect():
	pass

func azurlineInit():
	if globalData.infoDs.has("g_azurlineBase"):
		base = globalData.infoDs["g_azurlineBase"]
		path = chaData.infoDs["cazurlineA"].dir
	if base != null:
		#初始化
		base.connect("onLoadGame",self,"loadGame")
		base.connect("onNewGame",self,"newGame")
		base.connect("backTitle",self,"backTitle")
		base.connect("onSaveGame",self,"onSaveGame")
		utils = globalData.infoDs["g_azurlineUtils"]
		gshop = globalData.infoDs.get("g_azurlineShop")
		gDiff = globalData.infoDs.get("g_azurlineDifficult")
		gSiren = globalData.infoDs.get("g_azurlineSiren")
		gResearch = globalData.infoDs.get("g_azurlineResearch")
		gllustrate = globalData.infoDs.get("g_azurlineIllustrate")
		gllustrate2 = globalData.infoDs.get("g_azurlineIllustrate2")
		itemIllus = globalData.infoDs.get("g_azurlineItemIllus")
		achieve = globalData.infoDs.get("g_azurlineAchievement")
		gEvent = globalData.infoDs.get("g_azurlineEvents")
		gEvent2 = globalData.infoDs.get("g_azurlineEventsNew")
		omg = globalData.infoDs.get("g_azurlineOMG")
		pvp = globalData.infoDs.get("g_azurlinePVP")
		relic = globalData.infoDs.get("g_azurlineRelic")
		gTalents = globalData.infoDs.get("g_azurlineTalents")
		net = load("%s/azurline_ctrl/Net.gd" % [path]).new()
		sys.add_child(net)
		OS.window_maximized = true

func backTitle():
	resetData()

func onSaveGame():
	var tmp = {}
	tmp["pt"] = pt
	tmp["allAzurlineFlag"] = allAzurlineFlag
	tmp["uiFlag"] = uiFlag
	tmp["loan"] = loan
	tmp["crewTraining"] = crewTraining
	tmp["upCha"] = upCha
	tmp["upChaName"] = upChaName
	tmp["miuChas"] = miuChas
	tmp["buyLotteryNum"] = buyLotteryNum
	tmp["uploadCount"] = pvp.uploadCount
	tmp["ptRate"] = gshop.ptRate
	tmp["commentNum"] = commentNum
	tmp["selectedBonus"] = selectedBonus
	tmp["selectedTactialSup"] = selectedTactialSup
	tmp["tactialSupportLv"] = tactialSupportLv
	tmp["tactialSupportExp"] = tactialSupportExp
	tmp["tactialSupportCd"] = tactialSupportCd
	tmp["gunMaster"] = gunMaster
	tmp["healHpL"] = healHpL
	tmp["shieldBonus"] = shieldBonus
	tmp["miuProject"] = miuProject
	tmp["holyShield"] = holyShield
	tmp["convertShipType"] = convertShipType
	tmp["commanderTraining"] = commanderTraining
	tmp["holyShieldRein"] = holyShieldRein
	tmp["apadMaster"] = apadMaster
	tmp["allStar"] = allStar
	tmp["step"] = gDiff.step
	tmp["deathChas"] = gDiff.deathChas
	tmp["eventItemsR"] = gshop.eventItemsR
	tmp["checkedPrice"] = gshop.checkedPrice
	tmp["skipCost"] = gshop.skipCost
	tmp["campMaster"] = campMaster
	tmp["addiPop"] = addiPop
	tmp["heavyArmorFlag"] = relic.heavyArmorFlag
	tmp["mediumArmorFlag"] = relic.mediumArmorFlag
	tmp["failKing"] = failKing
	tmp["failProtect"] = failProtect
	tmp["globalItemSlot"] = globalItemSlot
	
	base.setData("azurCtrl", tmp)
	if allAzurlineFlag:
		saveChas()

	gEvent2.onSaveGame()

func loadGame():
	base.setSetting("loadGame", true)
	resetData()
	loadData()
	gameCtrl()
	yield(sys.get_tree().create_timer(0.5), "timeout")
	emit_signal("onLoadGame")

func loadData():
	var tmp = base.getData("azurCtrl", {})
	if not tmp.empty():
		pt = tmp["pt"]
		allAzurlineFlag = tmp["allAzurlineFlag"]
		uiFlag = tmp["uiFlag"]
		loan = tmp["loan"]
		crewTraining = tmp["crewTraining"]
		upCha = tmp["upCha"]
		upChaName = tmp["upChaName"]
		miuChas = tmp["miuChas"]
		buyLotteryNum = tmp["buyLotteryNum"]
		pvp.uploadCount = tmp["uploadCount"]
		gshop.ptRate = tmp["ptRate"]
		gDiff.step = tmp["step"]
		commentNum = tmp["commentNum"]
		selectedBonus = tmp["selectedBonus"]
		selectedTactialSup = tmp["selectedTactialSup"]
		tactialSupportLv = tmp["tactialSupportLv"]
		tactialSupportExp = tmp["tactialSupportExp"]
		tactialSupportCd = tmp["tactialSupportCd"]
		healHpL = tmp["healHpL"]
		shieldBonus = tmp["shieldBonus"]
		miuProject = tmp["miuProject"]
		holyShield = tmp["holyShield"]
		gunMaster = tmp["gunMaster"]
		convertShipType = tmp["convertShipType"]
		commanderTraining = tmp["commanderTraining"]
		holyShieldRein = tmp["holyShieldRein"]
		apadMaster = tmp["apadMaster"]
		allStar = tmp["allStar"]
		gshop.eventItemsR = tmp["eventItemsR"]
		gshop.checkedPrice = tmp["checkedPrice"]
		gshop.skipCost = tmp["skipCost"]
		campMaster = tmp["campMaster"]
		addiPop = tmp["addiPop"]
		relic.heavyArmorFlag = tmp["heavyArmorFlag"]
		relic.mediumArmorFlag = tmp["mediumArmorFlag"]
		gDiff.deathChas = tmp["deathChas"]
		failKing = tmp["failKing"]
		failProtect = tmp["failProtect"]
		globalItemSlot = tmp["globalItemSlot"]
		
	if allAzurlineFlag:
		loadChas()

func saveChas():
	var chas = []
	for i in sys.main.map.get_children():
		if i is Chara and i.team == 1 and not i.isSumm:chas.append(i)
	if chas.empty():
		chas = utils.getAllChas(2)
		if chas.empty():
			print("警告：自动存档时没有检测到场上存在角色")
	chas += utils.getReadyChas()
	var savedChas = []
	for i in chas:
		if i.get("tag") != "azurline":
			continue
		elif i.type == "npc":
			utils.removeAllEquip(i)
		savedChas.append(i.toJson())

	base.setData("chas", savedChas)
	saveItems(chas)

func saveItems(chas):
	var itemDic = {}
	var chaItemDic = {}
	for i in chas:
		for j in i.items:
			if i.get("rndId") != null:
				itemDic[j] = i.rndId
			if not chaItemDic.has(i.rndId):
				chaItemDic[i.rndId] = []
			if j.has_method("upgradeCheck"):
				chaItemDic.get(i.rndId).append(j.toJson())
			else:
				chaItemDic.get(i.rndId).append({"id":j.id})

	var items = []
	for i in sys.main.itemGrid.get_children():
		if i.item == null or itemDic.has(i.item):continue
		if not i.item.has_method("upgradeCheck"):
			items.append({"id":i.item.id})
		else:
			items.append(i.item.toJson())
	base.setData("items", items)
	base.setData("chaItems", chaItemDic)

func loadChas():
	var chasData = base.getData("chas", [])
	# #删除所有角色
	var chas = utils.getAllChas(2)
	chas += utils.getReadyChas()
	var index = chas.size() - 1
	while index >= 0:
		if chas[index].get("tag") == "azurline":
			chas[index].deleteSelf()
		index -= 1

	var chaDic = {}
	for i in chasData:
		var cha = sys.main.newChara(i.id, 1)
		if i.has("cell"):
			sys.main.map.add_child(cha)
			cha.isDrag = true
			cha.isItem = false

		else:
			sys.main.player.addCha(cha)

		cha.fromJson(i)
		chaDic[cha.rndId] = cha
	loadItems(chaDic)

func loadItems(chaDic):
	#删除所有装备
	for i in sys.main.itemGrid.get_children():
		i.queue_free()

	var items = base.getData("items", [])
	var chaItems = base.getData("chaItems", {})
	for i in items:
		var im = sys.newItem(i.id)
		sys.main.player.addItem(im)
		if i.has("tag"):
			im.fromJson(i)
			im.afterFromJson(i)
	
	for i in chaItems.keys():
		if chaDic.has(int(i)):
			var cha = chaDic.get(int(i))
			for j in chaItems.get(i):
				var im = sys.newItem(j.id)
				sys.main.player.addItem(im)
				if im.has_method("fromJson"):
					im.fromJson(j)
				cha.addItem(im)
				if im.has_method("afterFromJson"):
					im.afterFromJson(j)

func buyLottery():
	buyLotteryNum += 1
	emit_signal("buyLottery")

func resetData():
	emit_signal("resetData")
	allAzurlineFlag = true
	uiFlag = false
	utils.mindCubeNum = 0
	pt = 0
	layertxt = null
	bgBtn = null
	switchBtn = null
	statisWindow = null
	statisContainer = null
	settingPanel = null
	loan = 0
	crewTraining = false
	upCha = null
	upChaName = "无"
	miuChas = []
	buyLotteryNum = 0
	commentNum = 0
	selectedBonus = []
	selectedTactialSup = null
	tactialSupportLv = 1
	tactialSupportExp = 0
	tactialSupportCd = 5
	gunMaster = null
	healHpL = 0
	shieldBonus = 0
	miuProject = 0
	holyShield = false
	convertShipType = {}
	commanderTraining = false
	holyShieldRein = false
	apadMaster = null
	campMaster = []
	specialFleetWindow = null
	bonusBtn = null
	addiPop = 0
	relic.heavyArmorFlag = false
	relic.mediumArmorFlag = false
	globalItemSlot = 0
	

func newGame():
	resetData()
	checkCharaData()
	base.setSetting("loadGame", false)
	gameCtrl()
	yield(sys.get_tree().create_timer(0.3), "timeout")
	emit_signal("onNewGame")
	if not checkedVersion:
		checkVersion()

# #删除开局装备
# var excludeRareItems = ["i_Hide_al_oldu", "i_Hide_al_dice", "i_Hide_al_dragonKing", "i_Hide_al_forgetEquip"]
# func removeInitialEquip():
# 	for i in sys.main.itemGrid.get_children():
# 		if not excludeRareItems.has(i.item.id):
# 			sys.main.itemGrid.remove_child(i)

func checkVersion():
	checkedVersion = true
	var localVersion = utils.readVersion()
	if localVersion == 0:return
	var res = net.sendRequest("/azurline/version", HTTPClient.METHOD_GET)
	if res == null:
		print("无返回数据")
		return
	res = JSON.parse(res).result
	if res == null:return
	if res.code != "success":
		print("请求失败")
		return
	var version = int(res.data)
	if localVersion < version:
		if utils.isMobile():
			sys.newBaseMsg("通知", "检测到本地碧蓝航线MOD不是最新版本，请前往创意工坊手动更新")
		else:
			sys.newBaseMsg("通知", "检测到本地碧蓝航线MOD不是最新版本，请等待steam推送最新更新(最长十分钟)，若无推送，重新订阅即可强制更新")


func gameCtrl():
	if allAzurlineFlag:
		uiCtrl()
		showCheatWarning()

	sys.main.connect("onBattleReady", self, "onBattleReady")
	sys.main.connect("onBattleEnd", self, "onBattleEnd")
	sys.main.connect("onBattleStart",self,"onBattleStart")

func showCheatWarning():
	var showCheatWarning = base.getSetting("showCheatWarning", true)
	if int(base.getSetting("difficult2", 1)) == 7 and showCheatWarning:
		sys.newBaseMsg("警告", "创世难度下，将进行严格的作弊检测，使用各种辅助MOD将可能导致游戏失败！")
		base.setSetting("showCheatWarning", false)

func onBattleReady():
	#所有G文件的onBattleReady应由此统一管理，以免产生乱序问题
	if uiFlag:
		#当前Up
		if gDiff.step % 5 == 0 or upCha == null:
			var up = utils.getRndSpecChaInfo()
			while up.id == upCha:
				up = utils.getRndSpecChaInfo()
			upCha = up.id
			upChaName = up.name
		if sys.main.player.maxHp < 400:
			sys.main.player.maxHp += 100
		sys.main.player.plusHp(200)
		gSiren.doSiren()
		gDiff.difficultOption()
		relic.onBattleReady()
		gEvent.onBattleReady()
		gEvent2.onBattleReady()
		emit_signal("onBattleReady")
		#最后执行base的onBattleReady，以确保自动存档的有效性
		base.onBattleReady()
			
func onBattleEnd():	
	#理财
	repayLoan()

#作弊检测
func cheatCheck():
	var cheatFlag = false
	if gDiff.difficult != 7:return
	#检查天赋
	for i in sys.main.player.talentDs.keys():
		if not utils.consts.officialTalents.has(i) and i.find("t_al_") == -1:
			cheatFlag = false
	#检查天赋数量
	if sys.main.player.talentDs.keys().size() > 16:	
		cheatFlag = false
	#检查人口	
	if sys.main.player.renKou - sys.main.player.lv - addiPop - relic.addiPop > 3 || sys.main.player.lv > 18 || sys.main.player.renKou > 18:
		cheatFlag = false
	if cheatFlag:
		sys.newBaseMsg("警告", "检测到作弊行为，惩戒使者即将抵达战场(创世难度禁止第三方辅助MOD)")
		for i in utils.getAllChas(1):
			if i.get("tag") != "azurline":continue
			i.summChara("cex___azurtoolmanGM")
			break

func onBattleStart():
	lastTime = 0
	if not uiFlag:return
	statis1 = {}
	statis2 = {}
	#取消作弊检查
	#cheatCheck()
	#特种舰队
	if base.getSetting("specialFleet2", false):
		var charas = utils.checkCharaType()
		var validNum = 0
		for i in charas.keys():
			if charas.get(i) > 0:
				validNum += 1
		if selectedBonus.empty() and validNum <= 2:return
		#检查塞壬数量
		var sirenNum = 0
		for i in utils.getAllChas(2):
			if i.get("type") == "siren":
				sirenNum += 1
		var p2 = 1
		if validNum == 1:
			p2 = 2
		for i in utils.getAllChas(2):
			if i.get("type") != "siren":
				if validNum > 2 or sirenNum > 2:
					i.addBuff(b_specialFleet.new(attOpts, -1, 2))
					sys.newBaseMsg("警告", "特种舰队模式已开启：检测到我方场上有超过2个舰种的舰娘，触发惩罚效果。如果您是误开启该模式，可在MOD设置中关闭")
				else:
					i.addBuff(b_specialFleet.new(selectedBonus, 1, p2))

class b_al_challenge:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_al_challenge"
		att.maxHpL = -0.4

class b_specialFleet:
	extends Buff
	var dispel = 2
	var selectedBonus
	var p1
	var p2
	func _init(selectedBonus, p1, p2):
		attInit()
		id = "b_specialFleet"
		self.selectedBonus = selectedBonus
		self.p1 = p1
		self.p2 = p2
	func _connect():
		for i in selectedBonus:
			for j in i.field:
				att.set(j, i.value*p1*p2)

func checkSpecPool():
	utils.specChas.clear()
	var disableSpecChas = base.getSetting("disableSpecChas", [])
	for i in utils.specChasAll:
		if not disableSpecChas.has(i.id):
			utils.specChas.append(i.duplicate(true))

func checkCharaData():
	checkSpecPool()

	utils.lv1.clear()
	utils.lv2.clear()
	utils.lv3.clear()
	utils.lv4.clear()

	utils.exLv3.clear()
	utils.exLv4.clear()
	print(chaData)

	for i in chaData.rndPool.items:
		if i[0].id.find("azurline") == -1:
			allAzurlineFlag = false
		match i[0].lv:
			1:
				utils.lv1.append(i[0].id)
			2:
				utils.lv2.append(i[0].id)
			3:
				utils.lv3.append(i[0].id)
			4:
				utils.lv4.append(i[0].id)

	for i in utils.specChas:
		utils.exLv3.append(i.id)
	for i in utils.specChas:
		utils.exLv4.append(i.id+"2")

	utils.exLv3 += utils.lv3
	utils.exLv4 += utils.lv4
	
func uiCtrl():
	uiFlag = true
	battleUI()
	if base.getSetting("specialFleet2", false):
		initSpecialFleet()
	
func battleUI():
	#战斗背景
	var uiNode = sys.main.get_node("ui")
	sys.main.get_node("scene/bg/bg").set_texture(base.loadImg(path, bg[base.getSetting("bgPic", 0)]))
	layertxt = utils.createRichTextLabel("当前层数:%d" % (sys.main.guankaMsg.lvStep - 2), uiNode, Vector2(1000, 50), Vector2(400, 0))
	layertxt.push_align(1)
	#控制面板
	createSettingPanel()

	var hbox = utils.createVBox(uiNode, Vector2(1300, 0))
	hbox.name = "azurBtnBox"
	utils.createItemButton(hbox, gshop, "活动商店Q", "openShop", [], Vector2(0, 0), KEY_Q)
	utils.createItemButton(hbox, self, "控制面板W", "setting", [], Vector2(0, 0), KEY_W)
	utils.createItemButton(hbox, self, "科研系统R", "openResearch", [], Vector2(0, 0), KEY_R, true)
	utils.createItemButton(hbox, self, "挑战系统T", "openChallenge", [], Vector2(0, 0), KEY_T, true)
	buildBattleStatis()

	if utils.isMobile() or sys.test:
		utils.createItemButton(uiNode, self, "修复角色卡死", "fixChara", [], Vector2(80, 0))

	emit_signal("initMainUI")

func createSettingPanel():
	settingPanel = WindowDialog.new()
	settingPanel.set_size(Vector2(600, 300))
	settingPanel.window_title = "碧蓝航线控制面板"
	sys.main.get_node("ui").add_child(settingPanel)

	var gridList = GridContainer.new()
	gridList.columns = 4
	gridList.rect_position = Vector2(80,50)
	settingPanel.add_child(gridList)

	utils.createItemButton(gridList, self, "切换背景", "switchBG", [])
	utils.createItemButton(gridList, self, "MOD说明", "guide", [])
	utils.createItemButton(gridList, self, "角色图鉴", "illustrate", [])
	utils.createItemButton(gridList, self, "特殊图鉴", "charaSearch", [])
	utils.createItemButton(gridList, self, "道具图鉴", "itemIllus", [])
	
	pvp.buildRankList(gridList)

	utils.createItemButton(gridList, self, "更新日志", "changeLog", [])
	utils.createItemButton(gridList, self, "成就系统", "achieve", [])
	utils.createItemButton(gridList, self, "当前遗物", "globalBonus", [])
	utils.createItemButton(gridList, self, "手动读档", "manualLoad", [])
	utils.createItemButton(gridList, self, "测试指令", "testCmd", [])

func fixChara():
	for i in sys.main.map.get_children():
		if i is Chara and i.team == 1 and not i.isSumm and not i.isDeath:	
			i.reCreate()
		elif i is Chara and i.team == 2 and i.att.hp <= 0:
			i.remove()

#测试指令
func testCmd():
	var cmdWindow = utils.createWindowDialog(sys.main.get_node("ui"), "测试指令", Vector2(450, 250))
	cmdWindow.name = "cmdWindow"
	cmdWindow.popup_exclusive = true
	cmdWindow.get_close_button().hide()
	var le = LineEdit.new()
	le.max_length = 100
	le.name = "le"
	cmdWindow.add_child(le)
	le.rect_position = Vector2(50, 50)
	# le.connect("text_changed", self, "inputLottery")
	utils.createItemButton(cmdWindow, self, "确定", "doCmd", [le], Vector2(210, 150))
	utils.createItemButton(cmdWindow, self, "取消", "cancelCmd", [], Vector2(270, 150))
	cmdWindow.popup_centered()

func doCmd(le):
	if le.text == "azurlaneTest4":
		omg.test4()
	if le.text == "azurlaneTest3":
		omg.test3()
	if le.text == "save":
		sys.main.saveInfo()
	cancelCmd()

func cancelCmd():
	sys.main.get_node("ui/cmdWindow").hide()
	sys.main.get_node("ui/cmdWindow").queue_free()

func showEquip(btn):
	var difficult = int(base.getSetting("difficult2", 1))
	if difficult == 1:
		sys.newBaseMsg("提示", "该功能在简单难度无法使用！")
		btn.disabled = true
		return
	gResearch.showEquip()

func openResearch(btn):
	var difficult = int(base.getSetting("difficult2", 1))
	if difficult == 1:
		sys.newBaseMsg("提示", "该功能在简单难度无法使用！")
		btn.disabled = true
		return
	gResearch.openResearch()

func openChallenge(btn):
	var difficult = int(base.getSetting("difficult2", 1))
	if difficult == 1:
		sys.newBaseMsg("提示", "该功能在简单难度无法使用！")
		btn.disabled = true
		return
	gSiren.openChallenge()

func itemIllus():
	itemIllus.openIllstrate()

func charaSearch():
	gllustrate2.openIllstrate()
	
#手动读档
func manualLoad():
	if base.data.empty():
		sys.newBaseMsg("提示", "当前无存档记录")
		return
	if sys.main.player.lv > 1 and not sys.test:
		sys.newBaseMsg("提示", "请在游戏开始时读档")
		return
	if sys.main.player.talentDs.size() > 0:
		sys.newBaseMsg("提示", "检测到已选择天赋，请在游戏开始时读档")
		return
		
	loadData()
	emit_signal("manualLoadGame")
	sys.main.loadInfoManual()

func globalBonus():
	relic.showRecord()

func setting():
	settingPanel.popup_centered()

func achieve():
	achieve.open()

#MOD说明
func guide():
	OS.shell_open(utils.consts.helpUrl)

#更新日志
func changeLog():
	utils.openHelpWindow(utils.readChangeLog())

#传奇图鉴
func illustrate():
	gllustrate.openIllstrate()

func getBase(id):
	if id==null:return ""
	var c="c"
	var n=0
	for i in id:
		if n==3:
			c+=i
		elif i=="_":
			n+=1
	return c

var bg = ["g_azurline/bg_normal.png", "g_azurline/bg_normal2.png"]
#切换背景
func switchBG():
	var bgIndex = base.getSetting("bgPic", 0)
	bgIndex += 1
	if bgIndex > bg.size()-1:
		bgIndex = 0
	base.setSetting("bgPic", bgIndex)
	sys.main.get_node("scene/bg/bg").set_texture(base.loadImg(path, bg[bgIndex]))
var pt = 0

#检查额外人口
func checkPop():
	return addiPop + relic.addiPop

#===============================================战斗统计相关===============================================
var statis1 = {}
var statis2 = {}
func getDefaultStatis(cha):
	return {"damage":0, "hurt":0, "deal":0, "team":cha.team, "name":cha.chaName, "cha":cha}
var statisContainer
var statisWindow
func battleStatis():
	loadStatis(1)
	var timeLabel = statisWindow.get_node("time")
	timeLabel.bbcode_text = "战斗时间：%d"%[int(lastTime)]
	statisWindow.popup_centered()
#上回合战斗时间
var lastTime = 0
func buildBattleStatis():
	statisWindow = utils.createWindowDialog(sys.main.get_node("ui"), "战斗统计", Vector2(1000, 600))

	utils.createItemButton(statisWindow, self, "我方", "loadStatis", [1], Vector2(50, 20))
	utils.createItemButton(statisWindow, self, "敌方", "loadStatis", [2], Vector2(105, 20))

	var timeLabel = utils.createRichTextLabel("战斗时间：%d"%[int(lastTime)], statisWindow, Vector2(150, 50), Vector2(190, 30))
	timeLabel.name = "time"

	var statisScroll = utils.createScrollContainer(statisWindow, Vector2(950, 480), Vector2(30, 100))
	statisContainer = utils.createVBox(statisScroll)

	var dpsBtn = sys.main.get_node("ui/dps/dpsBtn")
	dpsBtn.text = "战斗统计"
	# dpsBtn.connect("pressed", self, "battleStatis")
	utils.addShotCutToBtn(dpsBtn, KEY_S)

func loadStatis(team = 1):
	for i in statisContainer.get_children():
		i.queue_free()
	var statis
	if team == 1:
		statis = statis1
	else:
		statis = statis2
	var values = statis.values()
	values.sort_custom(self, "sortStatis")

	var grid = utils.createGridContainer(statisContainer, 5)
	for i in values:
		utils.createRichTextLabel("{0}".format({"0":i.name}), grid, Vector2(300, 50))
		utils.createRichTextLabel("[color=#FFA500]伤害{1}[/color]".format({"1":int(i.damage)}), grid, Vector2(170, 50))
		utils.createRichTextLabel("[color=#FF0000]承伤{2}[/color]".format({"2":int(i.hurt)}), grid, Vector2(170, 50))
		utils.createRichTextLabel("[color=#008000]治疗{3}[/color]".format({"3":int(i.deal)}), grid, Vector2(170, 50))
		utils.createItemButton(grid, self, "详情", "battleDetail", [i.cha])

func sortStatis(a, b):
	return a.damage > b.damage

func getStatisByCha(cha):
	var statis
	if cha.team == 1:
		statis = statis1.get(cha, getDefaultStatis(cha))
	else:
		statis = statis2.get(cha, getDefaultStatis(cha))
	return statis

func setStatisByCha(cha, statis):
	if cha.isSumm:return
	if cha.team == 1:
		statis1[cha] = statis
	else:
		statis2[cha] = statis

func battleDetail(cha):
	cha.battleDetail(cha, statisContainer)

#===============================================理财相关===============================================
#未还贷款
var loan:int = 0
#还贷
func repayLoan():
	if loan > 0:
		var pay = 50
		if relic.loanRelic:
			pay = 25
		sys.main.player.plusGold(-pay)
		loan -= pay
		loan = max(0, loan)

#借贷
func doLoan():
	if sys.main.guankaMsg.lvStep - 2 < 20:
		sys.newBaseMsg("提示", "20层以上才能贷款")
		return
	if loan > 0:
		sys.newBaseMsg("提示", "当前有未还清贷款")
		return
	plusPt(500)
	sys.main.player.plusGold(500)
	loan = 300 + 500 + 500*gshop.ptRate
	if relic.loanRelic:
		loan *= 0.5

func plusPt(num):
	pt += num * relic.ptRate
	gshop.refreshPtLabel()

#===============================================特种舰队===============================================
func initSpecialFleet():
	var btn = utils.createItemButton(sys.main.get_node("ui"), self, "特种舰队", "specialFleet", [], Vector2(1300, 600))
	btn.name = "specialFleetBtn"
	if sys.main.get_node("ui").has_node("tactialSupportBtn"):
		btn.rect_position.y -= 48
	# sys.main.connect("onBattleStart",self,"onBattleStart")
	sys.main.player.connect("onAddCha",self,"convertCha")
	if utils.shipTypeDic.empty():
		utils.fillShipTypeDic()

func convertCha(cha):
	yield(sys.get_tree().create_timer(0.2), "timeout")
	if cha.onEvo:return
	if cha.get("tag") != "azurline" or cha.chaName.find("「") == -1 or convertShipType.empty():return 
	var fromType = cha.chaName.rsplit("「")[1].rsplit("」")[0]
	if not utils.validTypes.has(fromType):return
	var charas = utils.checkCharaType()
	if charas.get(fromType) > 0:return
	var toType = convertShipType.type
	if fromType != toType:
		var newId = sys.rndListItem(utils.shipTypeDic.get(toType).get(String(cha.lv)))
		utils.evoCha(cha, newId)		

var specialFleetWindow
var bonusBtn
func specialFleet():
	if not is_instance_valid(specialFleetWindow) or not specialFleetWindow is WindowDialog:
		buildSFWindow()
	refreshBonusWindow()
	specialFleetWindow.popup_centered()

func buildSFWindow():
	specialFleetWindow = utils.createWindowDialog(sys.main.get_node("ui"), "特种舰队", Vector2(600, 500))
	var context = utils.createScrollContainer(specialFleetWindow, Vector2(550, 450), Vector2(30, 100))
	context.name = "context"
	utils.createItemButton(specialFleetWindow, utils, "说明", "openHelpWindow", [specialFleetText], Vector2(30, 30))

	var container = utils.createVBox(context)
	container.name = "vbox"

	bonusBtn = utils.createItemButton(specialFleetWindow, self, "选择增益", "selectBonus", [], Vector2(100, 30))
	if selectedBonus.size() >= 2:
		bonusBtn.disabled = true

	var lb = utils.createRichTextLabel("", container, Vector2(400, 250))
	lb.name = "lb"

	var hbox = utils.createHBox(container, Vector2(30, 450))
	utils.createLabel("强制舰种转换：", hbox)
	var optBtn = OptionButton.new()
	optBtn.add_item("关闭")
	optBtn.add_item("驱逐")
	optBtn.add_item("轻巡")
	optBtn.add_item("重巡")
	optBtn.add_item("战列")
	optBtn.add_item("航母")
	optBtn.add_item("辅助")
	hbox.add_child(optBtn)
	optBtn.connect("item_selected", self, "switchConvertType", [optBtn])
	if not convertShipType.empty():
		optBtn.select(convertShipType.index)

func switchConvertType(index, optBtn):
	if index == 0:
		convertShipType = {}
	else:
		convertShipType = {"index":index, "type":optBtn.get_item_text(index)}	

var specialFleetText = """
[color=#BDB76B]特种舰队模式：[/color]
若场上只有一种或两种舰种的舰娘，则获得巨大的增益效果
增益效果的种类可以自选两个，如选择[冷却速度][法强加成]
当场上的舰娘均为同一舰种，则获得的增益效果最大
若为2个舰种，则获得1/2的增益效果
超过2个舰种时，获得减益效果
塞壬、余烬、指挥官均不计入统计，但也不能吃到增益效果加成（塞壬、余烬不能超过2个）
开启强制舰种转换后，之后掉落的其他常规舰种舰娘会随机转化为同级的该舰种舰娘(可能得到限定舰娘)
场上已存在的舰种，不会触发强制转化
"""

var attOpts = [
	{"text":"攻击", "value":0.3, "field":["atkL"]},
	{"text":"法强", "value":0.3, "field":["mgiAtkL"]},
	{"text":"双防", "value":0.5, "field":["defL", "mgiDefL"]},
	{"text":"暴击/爆伤", "value":0.35, "field":["cri", "criR"]},
	{"text":"攻速", "value":0.5, "field":["spd"]},
	{"text":"冷却速度", "value":0.4, "field":["cd"]},
	{"text":"吸血", "value":0.5, "field":["suck", "mgiSuck"]}
]

func selectBonus():
	var bonusWindow = utils.createWindowDialog(specialFleetWindow, "选择增益", Vector2(600, 500))
	var vbox = utils.createVBox(bonusWindow)
	vbox.margin_top = 30
	vbox.margin_left = 30
	for i in attOpts:
		var hbox = utils.createHBox(vbox)
		var lb = utils.createRichTextLabel(utils.consts.colorGold + i.text, hbox, Vector2(400, 50))
		utils.createItemButton(hbox, self, "选择", "selAtt", [i, hbox, bonusWindow])
	bonusWindow.popup_centered()

func selAtt(opt, hbox, bonusWindow):
	selectedBonus.append(opt)
	hbox.hide()
	hbox.queue_free()
	refreshBonusWindow()
	if selectedBonus.size() >= 2:
		bonusWindow.hide()
		bonusWindow.queue_free()
		bonusBtn.disabled = true

func refreshBonusWindow():
	var context = specialFleetWindow.get_node("context")
	var charas = utils.checkCharaType()
	if charas.empty():return
	var lb = context.get_node("vbox/lb")
	lb.bbcode_text = "当前角色统计：\n"
	var validNum = 0
	for i in charas.keys():
		lb.bbcode_text += "[color=#DC143C]%s:%d"%[i, charas.get(i)]
		if charas.get(i) > 0:
			validNum += 1

	#检查塞壬数量
	var sirenNum = 0
	for i in utils.getAllChas(2):
		if i.get("type") == "siren":
			sirenNum += 1
	lb.bbcode_text += "[color=#DC143C]%s:%d"%["塞壬/余烬", sirenNum]

	lb.bbcode_text += "[/color]"

	if validNum > 2 or sirenNum > 2:
		lb.bbcode_text += "\n当前增益：[color=#DC143C]\n"
		for i in attOpts:
			lb.bbcode_text += "%s:%d%% "%[i.text, i.value*-100]
		return

	if selectedBonus.empty():
		lb.bbcode_text += "\n请选择增益(未选择增益将获得惩罚)"
	else:
		lb.bbcode_text += "\n当前增益：[color=#DC143C]\n"
		var p2 = 1
		if validNum == 1:
			p2 = 2
		for i in selectedBonus:
			lb.bbcode_text += "%s:%d%% "%[i.text, i.value*100*p2]
