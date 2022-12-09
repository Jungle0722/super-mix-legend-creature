extends Node
func _ready():
	randomize()
	build()
	loadGuide()
func _init():
	call_deferred("init")
func _connect():
	pass
var utils = null
var azurCtrl = null
var base = null
var path = null
func init():
	yield(sys.get_tree().create_timer(0.2), "timeout")
	if globalData.infoDs.has("g_azurlineBase"):
		base = globalData.infoDs["g_azurlineBase"]
		path = chaData.infoDs["cazurlineA"].dir
	if base != null:
		#初始化
		utils = globalData.infoDs["g_azurlineUtils"]
		azurCtrl = globalData.infoDs["g_azurline"]
		base.connect("backTitle",self,"backTitle")
		base.loadSetting()
		sys.add_child(self)
		if not utils.isMobile():
			var keyboard = load("%s/azurline_ctrl/Keyboard.gd" % [path]).new()
			keyboard.connect("key_s", self, "loadMenu")
			sys.get_node("/root/Control").add_child(keyboard)

func loadGuide():
	#加载看板娘，仅在没订阅补充包时加载
	if base.getSetting("enableGuide", true) and utils.plus == null:
		var bTex = TextureRect.new()
		bTex.set_texture(base.loadImg(path, "g_azurlineModConfig/guide.png"))
		bTex.rect_position = Vector2(1050, 100)
		sys.get_node("/root/Control").add_child(bTex)
	if base.getSetting("enableCoverPic", true) and utils.plus != null:
		loadBgUi()

func loadMenu():
	window.popup_centered()

func backTitle():
	if not utils.isMobile():
		var keyboard = load("%s/azurline_ctrl/Keyboard.gd" % [path]).new()
		keyboard.connect("key_s", self, "loadMenu")
		sys.get_node("/root/Control").add_child(keyboard)
	build()
	loadGuide()

func loadBgUi():
	var mainUi = sys.get_node("/root/Control")
	utils.createItemButton(mainUi, self, "切换背景图", "switchBg", [], Vector2(100, 600))
	utils.createItemButton(mainUi, self, "隐藏/显示UI", "hiddenUi", [], Vector2(100, 650))
	var bg = sys.get_node("/root/Control/TextureRect")
	bg.set_texture(utils.getCoverPic())
	sys.get_node("/root/Control/logo").hide()

var window
var helpWindow
var textBox
var rightBtn
var leftBtn

var hideFlag = false
func hiddenUi():
	var mainUi = sys.get_node("/root/Control/Panel2/Panel")
	if not hideFlag:
		mainUi.get_node("Button").hide()
		mainUi.get_node("Button2").hide()
		mainUi.get_node("Button6").hide()
		mainUi.get_node("Button7").hide()
		mainUi.get_node("Button5").hide()
		mainUi.get_node("Button3").hide()

		if mainUi.has_node("jiXuBtn"):mainUi.get_node("jiXuBtn").hide()

	else:
		mainUi.get_node("Button").show()
		mainUi.get_node("Button2").show()
		mainUi.get_node("Button6").show()
		mainUi.get_node("Button7").show()
		mainUi.get_node("Button5").show()
		mainUi.get_node("Button3").show()

		if mainUi.has_node("jiXuBtn"):mainUi.get_node("jiXuBtn").show()

	hideFlag = !hideFlag

func switchBg():
	var bg = sys.get_node("/root/Control/TextureRect")
	bg.set_texture(utils.getCoverPic())

func build():
	utils.createItemButton(sys.get_node("/root/Control"), self, "碧蓝航线MOD设置", "loadMenu", [], Vector2(100, 700))
	window = WindowDialog.new()
	window.set_size(Vector2(400, 600))
	window.window_title = "设置"
	sys.get_node("/root/Control").add_child(window)

	var statisScroll = ScrollContainer.new()
	statisScroll.name = "ScrollContainer"
	statisScroll.set_custom_minimum_size(Vector2(380, 580))
	statisScroll.rect_position = Vector2(50, 50)
	statisScroll.set_margin(0, 50)
	window.add_child(statisScroll)

	var vbox = VBoxContainer.new()
	statisScroll.add_child(vbox)

	#MOD说明
	utils.createItemButton(vbox, self, "MOD说明", "guide", [])
	utils.createItemButton(vbox, self, "更新日志", "changeLog", [])

	buildHelp()

	#限定池调整
	utils.createItemButton(vbox, self, "限定池调整", "changeSpeciPool")

	# #看板娘设置
	var guide = CheckButton.new()
	guide.text = "看板娘"
	guide.connect("pressed", self, "switchGuide", [guide])
	vbox.add_child(guide)
	if base.getSetting("enableGuide", true):
		guide.pressed = true

	#随机封面图
	if utils.plus != null:
		var coverPicBtn = CheckButton.new()
		coverPicBtn.text = "随机封面图"
		coverPicBtn.connect("pressed", self, "switchCoverPic", [coverPicBtn])
		vbox.add_child(coverPicBtn)
		if base.getSetting("enableCoverPic", true):
			coverPicBtn.pressed = true

	#特种舰队模式设置
	var expert = CheckButton.new()
	expert.text = "特种舰队模式"
	expert.connect("pressed", self, "switchSpecialFleet", [expert])
	vbox.add_child(expert)
	expert.pressed = base.getSetting("specialFleet2", false)

	#随机模式设置
	var h1 = utils.createHBox(vbox)
	var challengeMode = CheckButton.new()
	challengeMode.text = "挑战模式"
	challengeMode.connect("pressed", self, "switchChallengeMode", [challengeMode])
	h1.add_child(challengeMode)
	utils.createItemButton(h1, self, "查看本轮挑战", "showChallenge", [])
	challengeMode.pressed = base.getSetting("challengeMode", false)
		
	#最大天赋数量
	var hbox = HBoxContainer.new()
	utils.createLabel("最大天赋数：", hbox)
	var talents = OptionButton.new()
	talents.add_item("8", 8)
	talents.add_item("9", 9)
	talents.add_item("10", 10)
	talents.add_item("11", 11)
	talents.add_item("12", 12)
	talents.add_item("13", 13)
	talents.add_item("14", 14)
	talents.add_item("15", 15)
	talents.add_item("16", 16)
	hbox.add_child(talents)
	vbox.add_child(hbox)
	talents.connect("item_selected", self, "switchTalents", [talents])
	var talentSetting = base.getSetting("talentSetting", {"index":0,"size":8})
	talents.select(talentSetting.index)

	#难度
	var diffHbox = utils.createHBox(vbox)
	utils.createLabel("难度：", diffHbox)
	var diff = OptionButton.new()
	diff.add_item("简单")
	diff.add_item("普通")
	diff.add_item("困难")
	diff.add_item("地狱")
	diff.add_item("创世")
	diffHbox.add_child(diff)
	diff.connect("item_selected", self, "switchDiff", [diff])
	var difficult = int(base.getSetting("difficult2", 0))
	match difficult:
		1:difficult=0
		2:difficult=1
		4:difficult=2
		6:difficult=3
		7:difficult=4
	diff.select(difficult)
	utils.createLabel("初次游玩强烈建议简单难度", vbox)

	#移除非碧蓝MOD内容
	var remove = CheckButton.new()
	remove.text = "移除非碧蓝MOD内容"
	remove.connect("pressed", self, "switchClearMode", [remove])
	vbox.add_child(remove)
	remove.pressed = base.getSetting("clearMode", true)

func switchClearMode(btn):
	base.setSetting("clearMode", btn.pressed)

func switchGuide(btn):
	base.setSetting("enableGuide", btn.pressed)

func switchCoverPic(btn):
	base.setSetting("enableCoverPic", btn.pressed)

func switchChallengeMode(btn):
	base.setSetting("challengeMode", btn.pressed)
	if btn.pressed:
		sys.newBaseMsg("提醒", "挑战模式已开启！该模式仅在创世难度生效，详情点击[查看本轮挑战]按钮")

func showChallenge():
	sys.newBaseMsg("本轮挑战", "我方舰娘死亡时，下回合会给敌人额外刷出一个该舰娘(继承装备)")

func switchSpecialFleet(btn):
	base.setSetting("specialFleet2", btn.pressed)
	if btn.pressed:
		sys.newBaseMsg("提醒", "特种舰队模式下，若场上只有一种或两种舰种的舰娘，则获得巨大的增益效果，详情可在游戏中点击右下角的[特种舰队]按钮查看，请谨慎开启")

func switchTalents(index, btn):
	base.setSetting("talentSetting", {"index":index,"size":btn.get_selected_id()})

func switchDiff(index, btn):
	var diff = 1
	print(index)
	match index:
		0:diff=1
		1:diff=2
		2:diff=4
		3:diff=6
		4:diff=7
	base.setSetting("difficult2", diff)

func guide():
	OS.shell_open(utils.consts.helpUrl)

func changeLog():
	helpWindow.popup_centered()

#限定池调整
var poolWindow
func changeSpeciPool():
	if not is_instance_valid(poolWindow) or not poolWindow is WindowDialog:
		buildSpeciPoolWindow()
	refreshSpeciPool()
	poolWindow.popup_centered()

func buildSpeciPoolWindow():
	poolWindow = utils.createWindowDialog(window, "限定池调整", Vector2(900, 600))
	var context = utils.createScrollContainer(poolWindow, Vector2(830, 450), Vector2(30, 100))
	context.name = "context"

	var title = utils.createRichTextLabel("最多禁用10名角色，被禁用的角色不会在游戏中出现，当前已禁用：0/10", poolWindow, Vector2(800, 50))
	title.name = "title"
	title.rect_position = Vector2(30, 30)

	var grid = utils.createGridContainer(context, 3)
	grid.name = "grid"

func refreshSpeciPool():
	var grid = poolWindow.get_node("context/grid")
	for i in grid.get_children():
		i.queue_free()

	var title = poolWindow.get_node("title")	
	var disableSpecChas = base.getSetting("disableSpecChas", [])
	var disabledNum = 0
	for i in utils.specChasAll:
		var hbox = utils.createHBox(grid)
		var color = "[color=#33ff33]"
		var text = "禁用"
		if disableSpecChas.has(i.id):
			color = "[color=#DC143C]"
			text = "启用"
			disabledNum += 1
		utils.createRichTextLabel(color + i.name, hbox, Vector2(150, 50))
		utils.createItemButton(hbox, self, text, "changeSpeci", [text, i])
	title.bbcode_text = "最多禁用14名角色，被禁用的角色不会在游戏中出现，当前已禁用：%d/14"%disabledNum

func changeSpeci(txt, conf):
	var disableSpecChas = base.getSetting("disableSpecChas", [])
	if txt == "启用":
		disableSpecChas.erase(conf.id)
	else:
		if disableSpecChas.size() >= 14:
			sys.newBaseMsg("提醒", "最多禁用14名角色！")
			return
		disableSpecChas.append(conf.id)
	base.setSetting("disableSpecChas", disableSpecChas)
	refreshSpeciPool()

func buildHelp():
	#MOD说明
	helpWindow = WindowDialog.new()
	helpWindow.set_size(Vector2(1200, 650))
	helpWindow.window_title = "碧蓝航线更新日志"
	window.add_child(helpWindow)
	textBox = RichTextLabel.new()
	textBox.bbcode_enabled = true
	textBox.bbcode_text = utils.readChangeLog()
	textBox.margin_top = 30
	textBox.margin_left = 50
	textBox.rect_min_size = Vector2(1100, 600)
	helpWindow.add_child(textBox)	