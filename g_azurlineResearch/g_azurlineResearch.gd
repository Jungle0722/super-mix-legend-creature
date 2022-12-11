extends Node
func _ready():
	pass
func _init():
	call_deferred("init")
func _connect():
	pass
var utils = null
var azurCtrl = null
var itemSkills
var shop
var relic
var base = null
var path = null
var skillPool
var gSiren
var gDiff
var config
#主界面
var window
#科研数据标签
var researchDataLb
var researchData:int = 0
#当前科研角色配置
var charaTemps = []
#当前科研装备配置
var equipTemps = []

var charaCost:int = 100
var equipCost:int = 100

func init():
	if globalData.infoDs.has("g_azurlineBase"):
		base = globalData.infoDs["g_azurlineBase"]
		path = chaData.infoDs["cazurlineA"].dir
	if base != null:
		#初始化
		utils = globalData.infoDs["g_azurlineUtils"]
		shop = globalData.infoDs["g_azurlineShop"]
		itemSkills = globalData.infoDs["g_azurlineItemSkills"]
		gSiren = globalData.infoDs["g_azurlineSiren"]
		gDiff = globalData.infoDs["g_azurlineDifficult"]
		azurCtrl = globalData.infoDs["g_azurline"]
		azurCtrl.connect("resetData", self, "resetData")
		azurCtrl.connect("onLoadGame",self,"loadGame")
		azurCtrl.connect("manualLoadGame", self, "loadGame")
		base.connect("onStartGame",self,"gameCtrl")
		skillPool = globalData.infoDs["g_azurlineSkills"]
		relic = globalData.infoDs["g_azurlineRelic"]
		config = load("%s/azurline_ctrl/ResearchConfig.gd" % [path]).new()

func onSaveGame():
	var tmp = {}
	tmp["charaCost"] = charaCost
	tmp["equipCost"] = equipCost
	tmp["researchData"] = researchData
	base.setData("research", tmp)
	gSiren.onSaveGame()

func loadGame():
	var tmp = base.getData("research", {})
	if not tmp.empty():
		charaCost = tmp["charaCost"]
		equipCost = tmp["equipCost"]
		researchData = tmp["researchData"]

func gameCtrl():
	buildMainWindow()

func resetData():
	charaTemps.clear()
	for i in config.charaData:
		charaTemps.append(i)
	equipTemps.clear()
	for i in config.equipData:
		equipTemps.append(i)	
	researchData = 0
	window = null	
	charaCost = 100
	equipCost = 100

func openResearch():
	if not is_instance_valid(window):
		buildMainWindow()
	window.popup_centered()
	
func buildMainWindow():
	window = utils.createWindowDialog(sys.main.get_node("ui"), "科研系统", Vector2(700, 450))
	loadHeader()

func loadHeader():
	var hbox = utils.createHBox(window)
	hbox.name = "header"
	hbox.rect_position = Vector2(30, 30)
	researchDataLb = utils.createRichTextLabel("", hbox, Vector2(200, 50))
	refreshRData()
	utils.createItemButton(hbox, self, "帮助说明", "showGuide", [])
	var chaBtn = utils.createItemButton(hbox, self, "舰船研发", "charaResearch", [])
	chaBtn.name = "chaBtn"
	var equipBtn = utils.createItemButton(hbox, self, "装备研发", "equipResearch", [])
	equipBtn.name = "equipBtn"
	utils.createItemButton(hbox, self, "舰队科技", "showTech", [])

	var hbox2 = utils.createHBox(window)
	hbox2.rect_position = Vector2(100, 130)
	hbox2.name = "content"

#刷新科研数据标签
func refreshRData():
	researchDataLb.bbcode_text = "科研数据：[color=#DC143C]{0}".format({"0":researchData})

func showGuide():
	utils.openHelpWindow(config.guideText)

func charaResearch():
	if researchData < charaCost:
		sys.newBaseMsg("提示", "科研数据不足，需要：[color=#DC143C]%d"%charaCost)
		return
	if charaTemps.empty():
		sys.newBaseMsg("提示", "已完成全部科研舰娘")
		return
	disableRBtn()
	changeRData(-charaCost)
	charaCost += 100
	var hbox = window.get_node("content")
	for i in hbox.get_children():
		i.queue_free()
	var rolled = []
	#roll charas
	charaTemps.shuffle()
	while rolled.size() < 3 and not charaTemps.empty():
		var r = charaTemps.pop_front()
		rolled.append(r)
	for i in rolled:
		var vbox = utils.createVBox(hbox)
		var chaBt = utils.newChaBt(vbox, i + "2")
		utils.createItemButton(vbox, self, "   选择   ", "doCharaResearch", [i], Vector2(100, 180))

func changeRData(num):
	researchData += num
	refreshRData()

func clearContent():
	var hbox = window.get_node("content")
	for i in hbox.get_children():
		i.queue_free()	

func doCharaResearch(i):
	sys.newBaseMsg("提示", "研究成功！")
	utils.addPlayerCha(i)
	enableRBtn()		
	clearContent()

#禁用研究按钮
func disableRBtn():
	window.get_node("header/chaBtn").disabled = true
	window.get_node("header/equipBtn").disabled = true
func enableRBtn():
	window.get_node("header/chaBtn").disabled = false
	window.get_node("header/equipBtn").disabled = false
	
func equipResearch():
	if researchData < equipCost:
		sys.newBaseMsg("提示", "科研数据不足，需要：[color=#DC143C]%d"%equipCost)
		return
	if equipTemps.empty():
		sys.newBaseMsg("提示", "已完成全部科研装备")
		return
	disableRBtn()
	changeRData(-equipCost)
	var hbox = window.get_node("content")
	for i in hbox.get_children():
		i.queue_free()
	var rolled = []
	#roll equips
	equipTemps.shuffle()
	while rolled.size() < 9 and not equipTemps.empty():
		var r = equipTemps.pop_front()
		rolled.append(r)

	for i in rolled:
		var vbox = utils.createVBox(hbox)
		var obj = preload("res://ui/item/item.tscn").instance()
		obj.init(sys.newItem(i))
		obj.rect_position = Vector2(40, 30)
		obj.isDrag = false
		vbox.add_child(obj)
		utils.createItemButton(vbox, self, "   选择   ", "doEquipResearch", [i], Vector2(100, 180))

func doEquipResearch(id):		
	sys.newBaseMsg("提示", "研究成功！")
	equipCost += 10
	var it = sys.newItem("i_Hide_alrm_equipResearch")
	it.repair(id)
	sys.main.player.addItem(it)
	enableRBtn()	
	clearContent()

func showTech():
	sys.newBaseMsg("提示", "该功能正在开发中，下次一定上线！")

#装备融合  fl:辅料
func rongHe(fl, item):
	var a = item
	var b = fl
	var p = 0.3 + relic.rongLianBonus
	var sks = itemSkills.skills.get(fl.id)
	if sks == null:
		p = 0.5
	else:
		item.skills.append(fl.id)
		for i in sks:
			var sk = i.new()
			item.info += "\n" + sk.text
	a.att.maxHp += b.att.maxHp*p
	a.att.maxHpL += b.att.maxHpL*p
	a.att.atk += b.att.atk*p
	a.att.atkL += b.att.atkL*p
	a.att.mgiAtk += b.att.mgiAtk*p
	a.att.mgiAtkL += b.att.mgiAtkL*p
	a.att.atkRan += b.att.atkRan*p
	a.att.def += b.att.def*p
	a.att.mgiDef += b.att.mgiDef*p
	a.att.pen += b.att.pen*p
	a.att.mgiPen += b.att.mgiPen*p
	a.att.cri += b.att.cri*p
	a.att.criR += b.att.criR*p
	a.att.suck += b.att.suck*p
	a.att.mgiSuck += b.att.mgiSuck*p
	a.att.reHp += b.att.reHp*p
	a.att.spd += b.att.spd*p
	a.att.dod += b.att.dod*p
	a.att.cd += b.att.cd*p
	a.att.penL += b.att.penL*p
	a.att.mgiPenL += b.att.mgiPenL*p	