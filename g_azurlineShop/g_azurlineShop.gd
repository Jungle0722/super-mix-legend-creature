extends Node
func _ready():
	pass
func _init():
	call_deferred("shopInit")
func _connect():
	pass
var utils = null
var azurCtrl = null
var difficult
var base = null
var path = null
var ptRate:float = 2
var relic
var shopWindow
var checkedPrice:bool = false
var skipCost:int = 0
func shopInit():
	if globalData.infoDs.has("g_azurlineBase"):
		base = globalData.infoDs["g_azurlineBase"]
		path = chaData.infoDs["cazurlineA"].dir
	if base != null:
		#初始化
		utils = globalData.infoDs["g_azurlineUtils"]
		azurCtrl = globalData.infoDs["g_azurline"]
		azurCtrl.connect("resetData", self, "resetData")
		relic = globalData.infoDs["g_azurlineRelic"]
		difficult = globalData.infoDs["g_azurlineDifficult"]

var shopPtLabel = Label.new()
var ptRateLabel = Label.new()
func resetData():
	ptRate = 2
	shopPtLabel = null
	ptRateLabel = null
	shopWindow = null
	skipCost = 0
	eventItemsR = {}
	checkedPrice = false
	for key in eventItems.keys():
		eventItemsR[key] = eventItems.get(key).duplicate(true)

#打开商店
func openShop():
	if not is_instance_valid(shopWindow) or not shopWindow is WindowDialog:
		createShop()
	loadItems()
	shopWindow.popup_centered()

#创建商店
func createShop():
	shopWindow = WindowDialog.new()
	shopWindow.set_size(Vector2(900, 520))
	shopWindow.window_title = "活动商店"
	sys.main.get_node("ui").add_child(shopWindow)

	var gridList = GridContainer.new()
	gridList.columns = 6
	gridList.rect_position = Vector2(100, 120)
	gridList.set_custom_minimum_size(Vector2(700,0))
	gridList.name = "grid"
	shopWindow.add_child(gridList)
	shopWindow.add_child(loadPtItem())
	# loadItems()

	ptRateLabel = Label.new()
	ptRateLabel.text = "当前PT金币兑换比例：[color=#DC143C]{0}".format({"0":ptRate})
	ptRateLabel.rect_position = Vector2(100, 440)
	refreshPtLabel()
	shopWindow.add_child(ptRateLabel)

	utils.createItemButton(shopWindow, self, "售卖角色", "sellCharas", [], Vector2(720, 440))
	utils.createItemButton(shopWindow, self, "快速跳关", "skipStep", [], Vector2(610, 440))

func skipStep():
	if sys.main.isAiStart:return
	if sys.main.batType == 2:
		sys.newBaseMsg("提示", "BOSS关无法跳关！")
		return
	if not shopWindow.has_node("skipStepWindow"):
		buildSkipStep()
	refreshSkipStepLabel()
	shopWindow.get_node("skipStepWindow").popup_centered()

func buildSkipStep():
	var skipStepWindow = utils.createWindowDialog(shopWindow, "快速跳关", Vector2(500, 250))
	skipStepWindow.name = "skipStepWindow"
	var next = getNextBossStep()
	var lb = utils.createRichTextLabel("", skipStepWindow, Vector2(420, 70), Vector2(40, 60))
	lb.name = "lb"
	utils.createItemButton(skipStepWindow, self, "确定", "doSkip", [], Vector2(175, 150))
	utils.createItemButton(skipStepWindow, self, "取消", "cancelSkip", [], Vector2(235, 150))

func refreshSkipStepLabel():
	shopWindow.get_node("skipStepWindow/lb").bbcode_text = utils.consts.colorGold + "将花费[color=#DC143C]{cost}[/color]PT跳到下一个BOSS关卡之前：[color=#DC143C]{st}[/color]关".format({"cost":skipCost,"st":getNextBossStep()})

func doSkip():
	sys.main.guankaMsg.lvStep = getNextBossStep()
	if skipCost > 0:
		azurCtrl.plusPt(-skipCost)
	skipCost += 256
	cancelSkip()

func getNextBossStep():
	var step = sys.main.guankaMsg.lvStep - 2
	if step < 27:
		return 26
	elif step < 54:
		return 53
	elif step < 81:
		return 80
	elif step < 108:
		return 107
	elif step < 135:
		return 134
	else:
		return 160

func cancelSkip():
	shopWindow.get_node("skipStepWindow").hide()

func sellCharas():
	if not shopWindow.has_node("sellWindow"):
		buildSellChas()
	shopWindow.get_node("sellWindow").popup_centered()
	
func buildSellChas():
	var sellWindow = utils.createWindowDialog(shopWindow, "售卖角色", Vector2(750, 350))
	sellWindow.name = "sellWindow"
	var vbox = utils.createVBox(sellWindow)
	vbox.rect_position = Vector2(30, 30)
	utils.createRichTextLabel("批量售卖备战栏对应等级的[color=#DC143C]未装备任何道具[/color]的角色", vbox, Vector2(600, 50))
	utils.createItemButton(vbox, self, "一级角色(50金)", "doSellChas", [1])
	utils.createItemButton(vbox, self, "二级角色(150金)", "doSellChas", [2])
	utils.createItemButton(vbox, self, "三级角色(450金)", "doSellChas", [3])
	utils.createItemButton(vbox, self, "四级角色(1350金)", "doSellChas", [4])

func doSellChas(lv):
	for i in utils.getReadyChas():
		if i.lv == lv and i.items.empty() and i.id != "cex___al-merchant":
			sys.main.player.plusGold(getChasPrice(lv))
			utils.deleteCha(i)

func getChasPrice(lv):
	var p = 0
	match lv:
		1:p = 50
		2:p = 150
		3:p = 450
		4:p = 1350
	return p			

#加载商品
var eventItems = {
	"warriorExp": {
		"btnText": "兑换",
		"price": 400,
		"conn": "buyItem",
		"type": "item",
		"objId": "i_Hide_al_warriorExp",
		"usePt": true
	},
	"agreedProof": {
		"btnText": "兑换",
		"price": 475,
		"conn": "buyItem",
		"type": "item",
		"objId": "i_Hide_al_agreedProof",
		"usePt": true
	},
	"limitProof": {
		"btnText": "兑换",
		"price": 380,
		"conn": "buyItem",
		"type": "item",
		"objId": "i_Hide_al_limitProof",
		"usePt": true
	},
	"miu": {
		"btnText": "兑换",
		"price": 110,
		"conn": "buyItem",
		"type": "item",
		"objId": "i_Hide_al_μEquip",
		"usePt": true
	},
	"knowledgeBook": {
		"btnText": "兑换",
		"price": 200,
		"conn": "buyItem",
		"type": "item",
		"objId": "i_Hide_al_knowledgeBook",
		"usePt": true
	},
	"directFlag": {
		"btnText": "兑换",
		"price": 256,
		"conn": "buyItem",
		"type": "item",
		"objId": "i_Hide_al_directFlag",
		"usePt": true
	},
	"diaoYu": {
		"btnText": "兑换",
		"price": 225,
		"conn": "buyItem",
		"type": "item",
		"objId": "i_Hide_al_diaoYu",
		"usePt": true
	},
	"greenHat": {
		"btnText": "兑换",
		"price": 200,
		"conn": "buyItem",
		"type": "item",
		"objId": "i_Hide_al_greenHat",
		"usePt": true
	},
	"explosiveBag": {
		"btnText": "兑换",
		"price": 200,
		"conn": "buyItem",
		"type": "item",
		"objId": "i_Hide_al_explosiveBag",
		"usePt": true
	},
	"i_Hide_al_forgetEquip": {
		"btnText": "兑换",
		"price": 250,
		"conn": "buyItem",
		"type": "item",
		"objId": "i_Hide_al_forgetEquip",
		"usePt": true
	},
	"i_Hide_al_dingDianGM": {
		"btnText": "兑换",
		"price": 120,
		"conn": "buyItem",
		"type": "item",
		"objId": "i_Hide_al_dingDianGM",
		"usePt": true
	},
	
}

var eventItemsR = {}

#检查商店价格加成
func checkPrice(item):
	if checkedPrice:return item
	item.price *= relic.shopItemPrice
	return item

func loadItems():
	var gridList = shopWindow.get_node("grid")
	for i in gridList.get_children():
		i.queue_free()
	for key in eventItemsR.keys():
		var item = eventItemsR.get(key)
		item = checkPrice(item)
		var itemPanel = Panel.new()
		itemPanel.name = "panel"
		itemPanel.rect_min_size = Vector2(120, 150)
		var obj = preload("res://ui/item/item.tscn").instance()
		obj.init(sys.newItem(item.objId))
		obj.rect_position = Vector2(40, 30)
		obj.isDrag = false
		itemPanel.add_child(obj)
		var itemLab = Label.new()#价格label
		itemLab.align = 1#对齐方式，1是居中对齐
		if item.usePt:
			itemLab.text = "%d PT"%item.price
		else:
			itemLab.text = "%d 金"%item.price
		itemLab.rect_position = Vector2(25, 65)
		itemPanel.add_child(itemLab)
		createItemButton(itemPanel, item.btnText, item.conn, [item, itemLab])
		gridList.add_child(itemPanel)
	if relic.shopItemPrice != 1:
		checkedPrice = true

func loadPtItem():
	var hbox = HBoxContainer.new()
	hbox.add_child(utils.createTextureRect("g_azurline/pt.png"))
	shopPtLabel = Label.new()
	shopPtLabel.text = "已拥有PT点数：{0}".format({"0":azurCtrl.pt})
	hbox.add_child(shopPtLabel)
	hbox.rect_position = Vector2(100, 60)

	utils.createItemButton(hbox, self, "购买100PT", "buyPt", [])

	utils.createItemButton(hbox, self, "商品说明", "shopGuide", [])
	utils.createItemButton(hbox, self, "五连建造", "tenBuild", [])
	utils.createItemButton(hbox, self, "装备宝箱", "equipChest", [])
	return hbox

func refreshPtLabel():
	if is_instance_valid(shopPtLabel):
		shopPtLabel.text = "已拥有PT点数：{0}".format({"0":int(azurCtrl.pt)})
		ptRateLabel.text = "当前PT金币兑换比例：{0}".format({"0":ptRate})
func buyPt():
	if sys.main.player.gold < 100*ptRate:
		sys.newBaseMsg("购买结果", "购买失败：金币不足！")
		return
	azurCtrl.plusPt(100)
	sys.main.player.subGold(100*ptRate)
	ptRate += 0.05
	refreshPtLabel()
	
var shopGuideText = """
[color=#BDB76B]PT点数：[/color]可以和金币按比例兑换，换的PT越多，兑换比例越高
[color=#BDB76B]五连建造：[/color]花费220PT，从当前选择的种族中抽取五次，有0.5%概率获得4级角色，有概率获得胡德、长门等特殊角色
[color=#BDB76B]装备宝箱：[/color]花费270PT，从当前选择的装备中抽取三次，有概率获得稀有装备
"""
func shopGuide():
	utils.openHelpWindow(shopGuideText)

#购买物品
signal buyItem
func buyItem(conf, itemLab):
	if conf.usePt and azurCtrl.pt < conf.price:
		sys.newBaseMsg("购买结果", "购买失败：PT点数不足！")
		return
	if not conf.usePt and sys.main.player.gold < conf.price:
		sys.newBaseMsg("购买结果", "购买失败：金币不足！")
		return
	var item = sys.newItem(conf.objId)
	if item.get("itemType") == "masked":
		item.repair()
	sys.main.player.addItem(item)
	if conf.usePt:
		azurCtrl.pt -= conf.price
		refreshPtLabel()
		shopPtLabel.text = "已拥有PT点数：{0}".format({"0":azurCtrl.pt})
	else:
		sys.main.player.plusGold(-conf.price)
	emit_signal("buyItem")
	afterBuyItem(conf, itemLab)

func afterBuyItem(conf, itemLab):
	if conf.objId == "i_Hide_al_agreedProof":
		#约定的证明
		itemLab.text = itemLab.text.replace(String(conf.price), String(conf.price + 100))
		conf.price += 100
	if conf.objId == "i_Hide_al_μEquip":
		itemLab.text = itemLab.text.replace(String(conf.price), String(conf.price + 15))
		conf.price += 15
	if conf.objId == "i_Hide_al_heartKey":
		itemLab.text = itemLab.text.replace(String(conf.price), String(conf.price + 200))
		conf.price += 200
	if conf.objId == "i_Hide_al_diaoYu":
		itemLab.text = itemLab.text.replace(String(conf.price), String(conf.price + 999))
		conf.price += 999
	if conf.objId == "i_Hide_al_goldFinger":
		itemLab.text = itemLab.text.replace(String(conf.price), String(conf.price + 200))
		conf.price += 200
	if conf.objId == "i_Hide_al_equipBox":
		itemLab.text = itemLab.text.replace(String(conf.price), String(conf.price + 100))
		conf.price += 20
	if conf.objId == "i_Hide_al_greenHat":
		itemLab.text = itemLab.text.replace(String(conf.price), String(conf.price + 20))
		conf.price += 20
	if conf.objId == "i_Hide_al_explosiveBag":
		itemLab.text = itemLab.text.replace(String(conf.price), String(conf.price + 100))
		conf.price += 100	
		
#五连建造
func tenBuild():
	var price = 220
	if azurCtrl.pt < price:
		sys.newBaseMsg("购买结果", "购买失败：PT点数不足！")
		return
	utils.rollItem(0, 5)
	azurCtrl.pt -= price
	refreshPtLabel()
	shopPtLabel.text = "已拥有PT点数：{0}".format({"0":azurCtrl.pt})
	
#抽装备
signal equipChest
func equipChest():
	var price = 270
	if azurCtrl.pt < price:
		sys.newBaseMsg("购买结果", "购买失败：PT点数不足！")
		return
	utils.rollItem(3, 0)
	azurCtrl.pt -= price
	refreshPtLabel()
	shopPtLabel.text = "已拥有PT点数：{0}".format({"0":azurCtrl.pt})
	emit_signal("equipChest")

#创建购买商品按钮
func createItemButton(baseNode, text, callback, args=[]):
	var b = Button.new()
	b.rect_position = Vector2(30, 105)
	b.text = text

	b.connect("pressed", self, callback, args)
	baseNode.add_child(b)

	return b