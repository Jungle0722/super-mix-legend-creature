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
var diff
var base = null
var path = null
var window
var recordWindow
var shop
var research
var config
var omg
var buffUtil
var siren
func init():
	if globalData.infoDs.has("g_azurlineBase"):
		base = globalData.infoDs["g_azurlineBase"]
		path = chaData.infoDs["cazurlineA"].dir
	if base != null:
		#初始化
		utils = globalData.infoDs["g_azurlineUtils"]
		azurCtrl = globalData.infoDs["g_azurline"]
		# azurCtrl.connect("initMainUI", self, "initBonus")
		diff = globalData.infoDs["g_azurlineDifficult"]
		shop = globalData.infoDs["g_azurlineShop"]
		research = globalData.infoDs["g_azurlineResearch"]
		omg = globalData.infoDs["g_azurlineOMG"]
		buffUtil = globalData.infoDs["g_azurlineBuffs"]
		siren = globalData.infoDs["g_azurlineSiren"]
		azurCtrl.connect("onNewGame",self,"newGame")
		azurCtrl.connect("resetData", self, "resetData")
		azurCtrl.connect("manualLoadGame", self, "loadData")
		azurCtrl.connect("onLoadGame",self,"loadGame")
		config = load("%s/azurline_ctrl/RelicConfig.gd" % [path]).new()

func onSaveGame():
	var tmp = {}
	tmp["shieldBonus"] = shieldBonus
	tmp["betterFreeze"] = betterFreeze
	tmp["betterShaoShi"] = betterShaoShi
	tmp["addiPop"] = addiPop
	tmp["addiRongLian"] = addiRongLian
	tmp["ptRate"] = ptRate
	tmp["charaBuildBonus"] = charaBuildBonus
	tmp["evoFlag"] = evoFlag
	tmp["equipBonus"] = equipBonus
	tmp["deathWordBonus"] = deathWordBonus
	tmp["shopItemPrice"] = shopItemPrice
	tmp["sirenTicketBonus"] = sirenTicketBonus
	tmp["picked"] = picked
	tmp["rongLianBonus"] = rongLianBonus
	tmp["caiPiaoBonus"] = caiPiaoBonus
	tmp["louShuiRelic"] = louShuiRelic
	tmp["loanRelic"] = loanRelic

	base.setData("relic", tmp)
	omg.onSaveGame()

func loadGame():
	loadData()
	sys.main.connect("onBattleStart",self,"onBattleStart")

func loadData():
	var tmp = base.getData("relic", {})
	if not tmp.empty():
		shieldBonus = tmp["shieldBonus"]
		betterFreeze = tmp["betterFreeze"]
		betterShaoShi = tmp["betterShaoShi"]
		addiPop = tmp["addiPop"]
		addiRongLian = tmp["addiRongLian"]
		ptRate = tmp["ptRate"]
		charaBuildBonus = tmp["charaBuildBonus"]
		evoFlag = tmp["evoFlag"]
		equipBonus = tmp["equipBonus"]
		deathWordBonus = tmp["deathWordBonus"]
		shopItemPrice = tmp["shopItemPrice"]
		sirenTicketBonus = tmp["sirenTicketBonus"]
		picked = tmp["picked"]
		rongLianBonus = tmp["rongLianBonus"]
		caiPiaoBonus = tmp["caiPiaoBonus"]
		louShuiRelic = tmp["louShuiRelic"]
		loanRelic = tmp["loanRelic"]

func newGame():
	if azurCtrl.allAzurlineFlag:
		sys.main.connect("onBattleStart",self,"onBattleStart")

func resetData():
	window = null
	recordWindow = null
	#护盾加成
	shieldBonus = 1
	#霜冻强化
	betterFreeze = false
	#烧蚀强化
	betterShaoShi = false
	#额外人口
	addiPop = 0
	#额外熔炼次数
	addiRongLian = 0
	#pt点数倍率
	ptRate = 1
	#五连建造加成标记
	charaBuildBonus = 0
	#进化额外获得角色标记
	evoFlag = false
	#装备三合一加成标记
	equipBonus = 1.0
	#亡语额外触发
	deathWordBonus = false
	#商店商品价格
	shopItemPrice = 1.0
	#挑战券获得速度（额外数量
	sirenTicketBonus = 0

	rongLianBonus = 0.0
	caiPiaoBonus = 1.0
	louShuiRelic = false
	loanRelic = false

	picked.clear()
	rolled.clear()

func onStartGame():
	pass

func onBattleStart():
	for i in picked:
		if i.get("onBattleStart") != true:continue
		var id = int(i.id)
		match id:
			5:sys.main.player.plusGold(20)
			6:azurCtrl.plusPt(10)

		if i.get("loopAlly") == true:
			for cha in utils.getAllChas(2):
				if id == 7 or id == 8 or id == 9:
					if i.shipType.has(utils.getChaType(cha)):
						cha.addBuff(buffUtil.b_atkR.new(3, 0, false))
				elif id == 10 or id == 11:
					if i.shipType.has(utils.getChaType(cha)):
						cha.addBuff(buffUtil.b_cd.new(3))
				elif id == 12:
					cha.addBuff(config.b_rel_ywxk.new())
				elif id == 13:
					cha.addBuff(config.b_rel_lzjd.new())
				elif id == 16:
					cha.addBuff(config.b_rel_fltys.new())
				elif id == 24:
					cha.addBuff(config.b_rel_lzgm.new())
				elif id == 25:
					cha.addBuff(config.b_rel_fqdd.new())
				elif id == 31:
					cha.addBuff(config.b_rel_jstcq.new())
				elif id == 35:
					cha.addBuff(buffUtil.b_wudi.new(2))
				elif id == 40 and cha.get("gunType") == "小型":
					cha.addBuff(config.b_rel_shengJ.new())
				elif id == 43:
					cha.addBuff(buffUtil.b_rel_xianliufa.new())
				elif id == 44:
					cha.addBuff(buffUtil.b_rel_wangpaijz.new())

		if i.get("loopEnemy") == true:
			for cha in utils.getAllChas(1):
				if id == 15 and cha.get("type") == "BOSS":
					cha.forceHurtSelf(cha.att.maxHp*0.3)
				if id == 26 and i.get("type") != "BOSS":
					cha.forceHurtSelf(cha.att.maxHp)
					break

func onBattleReady():
	if sys.main.batType == 2 and diff.step < 100:
		open()
	
func showRecord():
	if not is_instance_valid(recordWindow) or not recordWindow is WindowDialog:
		recordWindow = utils.createWindowDialog(sys.main.get_node("ui"), "当前遗物", Vector2(600, 450))
		var vbox1 = utils.createVBox(recordWindow)
		vbox1.rect_position = Vector2(30, 100)
		for j in picked:
			utils.createRichTextLabel("[color=#DC143C]%s[/color] - %s"%[j.name, j.desc], vbox1, Vector2(550, 50))
	recordWindow.popup_centered()

var rolled = []
var picked = []
func initUi():
	window = utils.createWindowDialog(sys.main.get_node("ui"), "选择遗物", Vector2(1100, 400))
	window.popup_exclusive = true
	window.get_close_button().hide()

	var hbox = utils.createHBox(window)
	hbox.rect_position = Vector2(30, 70)
	hbox.name = "hbox"

func open():
	if not is_instance_valid(window) or not window is WindowDialog:
		initUi()
	var hbox = window.get_node("hbox")
	for i in hbox.get_children():
		i.queue_free()
	rollRelic()
	# hbox.set_alignment(1)
	for i in rolled:
		var itemPanel = Panel.new()
		itemPanel.name = "panel"
		itemPanel.rect_min_size = Vector2(350, 250)
		hbox.add_child(itemPanel)
		# var img = utils.createTextureRect("g_azurlineRelic/" + i.ico)
		# itemPanel.add_child(img)
		# img.rect_position = Vector2(140, 50)

		utils.createRichTextLabel("[color=#BDB76B]" + i.name, itemPanel, Vector2(250, 50), Vector2(125, 40))
		utils.createRichTextLabel(i.desc, itemPanel, Vector2(300, 150), Vector2(30, 90))
		utils.createItemButton(itemPanel, self, "   选择   ", "doGetRelic", [i], Vector2(125, 180))

	window.popup_centered()	

func doGetRelic(conf):
	if conf.get("instant") == true:
		afterGetRelic(conf)
	picked.append(conf)
	window.hide()
	var hbox = window.get_node("hbox")
	for i in hbox.get_children():
		i.queue_free()

#护盾加成
var shieldBonus:float = 1
#霜冻强化
var betterFreeze:bool = false
#烧蚀强化
var betterShaoShi:bool = false
#额外人口
var addiPop:int = 0
#额外熔炼次数
var addiRongLian:int = 0
#重甲转超重甲，该数据的存档交由azurCtrl控制
var heavyArmorFlag:bool = false
#pt点数倍率
var ptRate:float = 1
#五连建造加成标记
var charaBuildBonus:int = 0
#进化额外获得角色标记
var evoFlag:bool = false
#装备三合一加成标记
var equipBonus:float = 1.0
#亡语额外触发
var deathWordBonus:bool = false
#商店商品价格
var shopItemPrice:float = 1.0
#挑战券获得速度（额外数量
var sirenTicketBonus:int = 0

#中甲转超重甲，该数据的存档交由azurCtrl控制
var mediumArmorFlag:bool = false
#熔炼系数
var rongLianBonus:float = 0.0
#彩票收益系数
var caiPiaoBonus:float = 1.0
#漏水遗物
var louShuiRelic:bool = false
#贷款遗物
var loanRelic:bool = false

func afterGetRelic(conf):
	match conf.id:
		1:shieldBonus = conf.num
		2:sys.main.player.addCha(sys.main.newChara(sys.rndListItem(utils.consts.relicChas).objId))
		3:betterFreeze = true
		4:betterShaoShi = true
		14:
			addiPop += 1
			sys.main.upPop()
		17:addiRongLian += 2
		18:
			heavyArmorFlag = true
			for i in utils.getAllChas(2) + utils.getReadyChas():
				if i.get("armorType") == "重型":
					i.armorType = "超重型"
		19:ptRate = 1.3
		20:utils.rollItem(0, 1, "获得角色", 1000)
		21:azurCtrl.plusPt(500)
		22:shop.ptRate -= 0.5
		23:evoFlag = true
		28:equipBonus = 1.5
		29:charaBuildBonus = 20
		30:deathWordBonus = true
		32:shopItemPrice -= 0.3
		33:sirenTicketBonus = 1
		34:
			mediumArmorFlag = true
			for i in utils.getAllChas(2) + utils.getReadyChas():
				if i.get("armorType") == "中型":
					i.armorType = "超重型"
		36:
			research.changeRData(100)
		37:siren.darkFood = true
		38:rongLianBonus = 0.3
		39:caiPiaoBonus = 2.0
		41:louShuiRelic = true
		42:loanRelic = true
		
func rollRelic():
	rolled.clear()
	for i in range(3):
		var bf = sys.rndListItem(config.buffTemplates)
		while rolled.has(bf) or picked.has(bf):
			bf = sys.rndListItem(config.buffTemplates)
		rolled.append(bf)
	
		

