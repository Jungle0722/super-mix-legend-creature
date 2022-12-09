extends Node
func _ready():
	pass
func _init():
	call_deferred("init")
func _connect():
	pass
var utils = null
var azurCtrl = null
var gBattle
var research
var diff
var base = null
var path = null
var window
func init():
	if globalData.infoDs.has("g_azurlineBase"):
		base = globalData.infoDs["g_azurlineBase"]
		path = chaData.infoDs["cazurlineA"].dir
	if base != null:
		#初始化
		utils = globalData.infoDs["g_azurlineUtils"]
		azurCtrl = globalData.infoDs["g_azurline"]
		azurCtrl.connect("onLoadGame",self,"loadGame")
		base.connect("onNewGame",self,"onNewGame")
		azurCtrl.connect("initMainUI", self, "buildArchiUI")
		diff = globalData.infoDs["g_azurlineDifficult"]
		research = globalData.infoDs["g_azurlineResearch"]

func onNewGame():
	gameCtrl()
	var achiOther = base.getSetting("achiOther", [])
	for i in achiOther:
		match i:
			"duShen":sys.main.player.addItem(sys.newItem("i_Hide_al_dice"))
			"siren":sys.main.player.addItem(sys.newItem("i_Hide_al_forgetEquip"))
			"dragonKing":sys.main.player.addItem(sys.newItem("i_Hide_al_dragonKing"))
			"worldGod":
				if int(base.getSetting("difficult2", 1)) == 7 and base.getSetting("challengeMode", false):
					sys.main.player.addItem(utils.getRndItem())
					

func loadGame():
	gameCtrl()

func gameCtrl():
	sys.main.connect("onTongGuan", self, "afterTongGuan")

func resetData():
	pass

func buildArchiUI():
	window = utils.createWindowDialog(sys.main.get_node("ui"), "成就系统", Vector2(1150, 600))

	# var statisScroll = ScrollContainer.new()
	# statisScroll.set_custom_minimum_size(Vector2(1070, 450))
	# statisScroll.rect_position = Vector2(10, 10)
	# statisScroll.margin_top = 100
	# statisScroll.margin_left = 50
	# window.add_child(statisScroll)
	var statisScroll = utils.createScrollContainer(window, Vector2(1070, 450), Vector2(10, 10))
	statisScroll.margin_top = 100
	statisScroll.margin_left = 50
	var context = utils.createVBox(statisScroll)
	context.margin_top = 100
	context.margin_left = 50
	# statisScroll.add_child(context)

	var btn = utils.createItemButton(window, self, "成就总览", "showTotal")
	btn.rect_position = Vector2(50, 30)

	var achiChara = base.getSetting("achiChara", {})
	# var hbox = utils.createVBox(context)
	for i in achiChara.keys():
		var name = achiChara.get(i)
		utils.createRichTextLabel("[color=#DC143C][真爱！{name}][/color]：战斗开始时，名字中带有{name}的舰娘，四维/血量提高12%".format({"name":name}), context, Vector2(1000, 50))

	var achiCamp = base.getSetting("achiCamp", [])
	for i in achiCamp:
		match i:
			"by":utils.createRichTextLabel("[color=#DC143C][白鹰海军上将][/color]：解锁军旗升级功能，且无副作用", context, Vector2(1000, 50))
			"cy":utils.createRichTextLabel("[color=#DC143C][重樱联合舰队总司令][/color]：解锁军旗升级功能，且无副作用", context, Vector2(1000, 50))
			"hj":utils.createRichTextLabel("[color=#DC143C][皇家海军部长][/color]：解锁军旗升级功能，且无副作用", context, Vector2(1000, 50))
			"x":utils.createRichTextLabel("[color=#DC143C][碧蓝海军元帅][/color]：解锁军旗升级功能，且无副作用", context, Vector2(1000, 50))
			"z":utils.createRichTextLabel("[color=#DC143C][铁血海军司令][/color]：解锁军旗升级功能，且无副作用", context, Vector2(1000, 50))

	var achiOther = base.getSetting("achiOther", [])
	for i in achiOther:
		match i:
			"duShen":
				utils.createRichTextLabel("[color=#DC143C][赌神][/color]：在之后的游戏中，获得纪念道具：赌神的骰子", context, Vector2(1000, 50))
			"miu":
				utils.createRichTextLabel("[color=#DC143C][μ兵装出击][/color]：在之后的游戏中，星云舞裙不再需要等待10回合", context, Vector2(1000, 50))
			"siren":
				utils.createRichTextLabel("[color=#DC143C][塞壬统帅][/color]：在之后的游戏中，开局即获得道具：深度训练设备", context, Vector2(1000, 50))
			"warrior":
				utils.createRichTextLabel("[color=#DC143C][战士的感悟][/color]：在之后的游戏中，使用战士的心得进化所需回合数减半", context, Vector2(1000, 50))
			"dragonKing":
				utils.createRichTextLabel("[color=#DC143C][龙王][/color]：在之后的游戏中，开局即获得道具：喷水龙王", context, Vector2(1000, 50))
			"dragonGod":
				utils.createRichTextLabel("[color=#DC143C][龙神][/color]：喷水龙王解锁额外效果", context, Vector2(1000, 50))
			"hougongMaster":
				utils.createRichTextLabel("[color=#DC143C][后宫之主][/color]：在之后的游戏中，54关BOSS必定掉落特殊道具：真爱之戒", context, Vector2(1000, 50))
			"worldGod":
				utils.createRichTextLabel("[color=#DC143C][创世神][/color]：在挑战模式中，开局可额外获得一件随机装备", context, Vector2(1000, 50))
			"corePlayer":
				utils.createRichTextLabel("[color=#DC143C][硬核玩家][/color]：在之后的游戏中，81关BOSS必定掉落特殊道具：PlayStation6Pro", context, Vector2(1000, 50))

func open():
	window.popup_centered()

var allArchiText = """
[color=#BDB76B][真爱！]：[/color]
条件：使用两个相同的[color=#BDB76B]传奇[/color]舰娘通关无尽模式
奖励：在之后的游戏中，凡是名字带有XXX的角色，都会获得四维/血量提高12%的加成，该角色现代化改造便宜100金币
备注：例如使用两个黛朵·誓约通关后，将达成[真爱!黛朵]的成就，之后使用任何等级的黛朵，包括μ兵装和普通黛朵，都会获得加成

[color=#BDB76B][白鹰海军上将][/color]
条件：使用超过(含)10个[color=#BDB76B]传奇[/color]白鹰舰娘的阵容通关无尽模式
奖励：在之后的游戏中，解锁军旗升级功能，且无副作用

[color=#BDB76B][重樱联合舰队总司令][/color]
条件：使用超过(含)10个[color=#BDB76B]传奇[/color]重樱舰娘的阵容通关无尽模式
奖励：在之后的游戏中，解锁军旗升级功能，且无副作用

[color=#BDB76B][皇家海军部长][/color]
条件：使用超过(含)10个[color=#BDB76B]传奇[/color]皇家舰娘的阵容通关无尽模式
奖励：在之后的游戏中，解锁军旗升级功能，且无副作用

[color=#BDB76B][碧蓝海军元帅][/color]
条件：使用超过(含)10个[color=#BDB76B]传奇[/color]北方联合/自由鸢尾/其他阵营舰娘的阵容通关无尽模式
奖励：在之后的游戏中，解锁军旗升级功能，且无副作用

[color=#BDB76B][铁血海军司令][/color]
条件：使用超过(含)10个[color=#BDB76B]传奇[/color]铁血阵营舰娘的阵容通关无尽模式
奖励：在之后的游戏中，解锁军旗升级功能，且无副作用

[color=#BDB76B][赌神][/color]
条件：一局游戏中，购买至少10次彩票
奖励：在之后的游戏中，获得纪念道具：赌神的骰子

[color=#BDB76B][μ兵装出击][/color]
条件：无尽通关时，阵容包含了全部十种μ兵装舰娘（传奇等级）
奖励：在之后的游戏中，星云舞裙不再需要等待10回合

[color=#BDB76B][塞壬统帅][/color]
条件：使用超过(含)6个[color=#BDB76B]传奇[/color]塞壬的阵容通关无尽模式
奖励：在之后的游戏中，开局即获得道具：深度训练设备

[color=#BDB76B][战士的感悟][/color]
条件：一局游戏内使用战士的心得做出：厌战·改、彩布里、明石·撒币，并用其通关无尽模式
奖励：在之后的游戏中，使用战士的心得进化所需回合数减半

[color=#BDB76B][龙王]][/color]
条件：累计发表25次角色评论
奖励：在之后的游戏中，开局即获得道具：喷水龙王

[color=#BDB76B][龙神][/color]
条件：累计发表50次角色评论
奖励：喷水龙王解锁额外效果

[color=#BDB76B][后宫之主][/color]
条件：完成超过30个真爱成就
奖励：在之后的游戏中，54关BOSS必定掉落特殊道具：真爱之戒

[color=#BDB76B][创世神][/color]
条件：通关创世难度
奖励：在挑战模式中，开局可额外获得一件随机装备

[color=#BDB76B][硬核玩家][/color]
条件：通关挑战模式
奖励：在之后的游戏中，81关BOSS必定掉落特殊道具：PlayStation6Pro
"""

func showTotal():
	utils.openHelpWindow(allArchiText)
		
func afterTongGuan(x):
	if diff.step >= 161:
		achievement()

#通关时统计角色成就
func achievement():
	var chaMap = {}
	var campMap = {"重樱":0,"白鹰":0,"皇家":0,"铁血":0,"撒丁帝国":0,"北方联合":0,"自由鸢尾":0,"东煌":0,"其他":0,"塞壬":0}
	var warriors = []
	for i in sys.main.btChas:
		if i.team == 1 and i.get("tag") == "azurline":
			if i.lv == 4:
				if chaMap.has(i.id):
					chaMap[i.id].num += 1
				else:
					chaMap[i.id] = {"name":i.chaName, "num":1, "rl":false}
				for item in i.items:
					if item.id == "i_Hide_al_loveRing":
						chaMap[i.id].rl = true
					
			utils.dicPlus(campMap, i.get("camp"), 1)
			if i.get("type") == "siren":
				utils.dicPlus(campMap, "塞壬", 1)
			if i.id == "cex___al-warspite" or i.id == "cex___al-mingShi" or i.chaName.find("彩布里") > -1 and not warriors.has(i.id):
				warriors.append(i.id)

	var alertMsg = ""
	var achiChara = base.getSetting("achiChara", {})
	var miuChas = []
	for i in chaMap.keys():
		var chaConf = chaMap.get(i)
		if chaConf.name.find("μ兵装") > -1 and not miuChas.has(i):
			miuChas.append(i)
		if achiChara.has(i) or (chaMap.get(i).num < 2 and chaConf.rl == false):continue
		if chaMap.get(i).name.find("」") == -1:return
		var name = chaMap.get(i).name.rsplit("」")[1].rsplit("·")[0]
		achiChara[i] = name
		alertMsg += "成就：[color=#DC143C][真爱！%s][/color]已达成，可在控制面板-成就系统中查看\n"%name
	base.setSetting("achiChara", achiChara)
	var achiCamp = base.getSetting("achiCamp", [])
	if not achiCamp.has("by") and campMap.get("白鹰") >= 10:
		alertMsg += "成就：[color=#DC143C][白鹰海军上将][/color]已达成，可在控制面板-成就系统中查看\n"
		achiCamp.append("by")
	if not achiCamp.has("cy") and campMap.get("重樱") >= 10:
		alertMsg += "成就：[color=#DC143C][重樱联合舰队总司令][/color]已达成，可在控制面板-成就系统中查看\n"
		achiCamp.append("cy")
	if not achiCamp.has("hj") and campMap.get("皇家") >= 10:
		alertMsg += "成就：[color=#DC143C][皇家海军部长][/color]已达成，可在控制面板-成就系统中查看\n"
		achiCamp.append("hj")
	if not achiCamp.has("x") and campMap.get("北方联合") + campMap.get("自由鸢尾") + campMap.get("东煌") + campMap.get("其他") >= 10:
		alertMsg += "成就：[color=#DC143C][碧蓝海军元帅][/color]已达成，可在控制面板-成就系统中查看\n"
		achiCamp.append("x")
	if not achiCamp.has("z") and campMap.get("铁血") + campMap.get("撒丁帝国") >= 10:
		alertMsg += "成就：[color=#DC143C][铁血海军司令][/color]已达成，可在控制面板-成就系统中查看\n"
		achiCamp.append("z")
	base.setSetting("achiCamp", achiCamp)

	var achiOther = base.getSetting("achiOther", [])
	if not achiOther.has("duShen") and azurCtrl.buyLotteryNum >= 10:
		alertMsg += "成就：[color=#DC143C][赌神][/color]已达成，可在控制面板-成就系统中查看\n"
		achiOther.append("duShen")

	if not achiOther.has("miu") and miuChas.size() >= 10:
		alertMsg += "成就：[color=#DC143C][μ兵装出击][/color]已达成，可在控制面板-成就系统中查看\n"
		achiOther.append("miu")

	# if not achiOther.has("researchEquip") and research.finishedEquips.size() >= 3:
	# 	alertMsg += "成就：[color=#DC143C][科研大师][/color]已达成，可在控制面板-成就系统中查看\n"
	# 	achiOther.append("researchEquip")

	if not achiOther.has("siren") and campMap.get("塞壬") >= 6:
		alertMsg += "成就：[color=#DC143C][塞壬统帅][/color]已达成，可在控制面板-成就系统中查看\n"
		achiOther.append("siren")

	if not achiOther.has("warrior") and warriors.size() >= 3:
		alertMsg += "成就：[color=#DC143C][战士的感悟][/color]已达成，可在控制面板-成就系统中查看\n"
		achiOther.append("warrior")

	if not achiOther.has("hougongMaster") and achiChara.keys().size() >= 30:
		alertMsg += "成就：[color=#DC143C][后宫之主][/color]已达成，可在控制面板-成就系统中查看\n"
		achiOther.append("hougongMaster")

	if not achiOther.has("worldGod") and diff.difficult == 7:
		alertMsg += "成就：[color=#DC143C][创世神][/color]已达成，可在控制面板-成就系统中查看\n"
		achiOther.append("worldGod")

	if not achiOther.has("corePlayer") and diff.difficult == 7 and base.getSetting("challengeMode", false):
		alertMsg += "成就：[color=#DC143C][硬核玩家][/color]已达成，可在控制面板-成就系统中查看\n"
		achiOther.append("corePlayer")

	base.setSetting("achiOther", achiOther)
	
	if alertMsg != "":
		sys.newBaseMsg("通知", alertMsg)

func createItemButton(baseNode, text, callback, args=[]):
	var b = Button.new()
	b.rect_position = Vector2(20, 80)
	b.text = text
	b.connect("pressed", self, callback, args)
	baseNode.add_child(b)
	return b