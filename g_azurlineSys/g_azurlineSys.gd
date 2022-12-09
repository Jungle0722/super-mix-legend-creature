extends Node
func _ready():
	pass
func _init():
	call_deferred("init")
var utils = null
var azurCtrl = null
var base = null
var path = null
var mainScript = load(self.get_script().get_path().get_base_dir() + "/azurMain.gd")
var controlScript = load(self.get_script().get_path().get_base_dir() + "/azurControl.gd")
var playerScript = load(self.get_script().get_path().get_base_dir() + "/azurPlayer.gd")
func init():
	if globalData.infoDs.has("g_azurlineBase"):
		base = globalData.infoDs["g_azurlineBase"]
		path = chaData.infoDs["cazurlineA"].dir
	if base != null:
		#初始化
		utils = globalData.infoDs["g_azurlineUtils"]
		azurCtrl = globalData.infoDs["g_azurline"]
		call_deferred("_connect")
		base.connect("onStartGame", self, "onStartGame")
		azurCtrl.connect("resetData", self, "resetData")

func _connect():
	sys.get_tree().connect("node_added", self, "on_node_added")
	utils.changeScript(sys.get_node("/root/Control"), controlScript)

func on_node_added(node):
	if node is Main:
		utils.changeScript(node, mainScript)
	if node is Player:
		utils.changeScript(node, playerScript)

func resetData():
	speed = 1
	window = null

var speed = 1
var window
func onStartGame():
	speed = 1
	var originBtn = sys.main.get_node("ui/suDu/CheckButton")
	originBtn.hide()
	utils.createItemButton(sys.main.get_node("ui/suDu"), self, "变速(D)", "showSpeedWindow", [], originBtn.rect_position, KEY_D)

	if not is_instance_valid(window) or not window is WindowDialog:
		build()

func showSpeedWindow():
	window.popup_centered()
	
func build():
	yield(sys.get_tree().create_timer(1), "timeout")
	window = utils.createWindowDialog(sys.main.get_node("ui"), "调整游戏速度", Vector2(600, 250))
	sys.main.get_node("/root/").pause_mode = Node.PAUSE_MODE_PROCESS
	sys.main.get_node("/root/main/scene/TileMap").pause_mode = Node.PAUSE_MODE_STOP

	var spdLb = utils.createRichTextLabel("当前速度:%d" % speed, window, Vector2(1000, 50), Vector2(50, 200))
	spdLb.name = "spdLb"

	var hbox = utils.createHBox(window)
	hbox.rect_position = Vector2(50, 50)
	createItemButton(hbox, self, "暂停(空格)", "changeSpd", [spdLb, 0], Vector2(50, 150), "key_space")
	createItemButton(hbox, self, "0.5倍(Z)", "changeSpd", [spdLb, 0.5], Vector2(350, 150), "key_z")
	createItemButton(hbox, self, "1倍(X)", "changeSpd", [spdLb, 1], Vector2(100, 150), "key_x")
	createItemButton(hbox, self, "2倍(C)", "changeSpd", [spdLb, 2], Vector2(100, 150), "key_c")
	createItemButton(hbox, self, "3倍(V)", "changeSpd", [spdLb, 3], Vector2(100, 150), "key_v")
	
func changeSpd(spdLb, spd):
	speed = spd
	spdLb.bbcode_text = "当前速度:{spd}".format({"spd":spd})
	var map = sys.main.get_node("/root/main/scene/TileMap")
	if spd == 0:
		#暂停
		map.get_tree().paused = !map.get_tree().paused
		if map.get_tree().paused:
			for i in map.get_children():
				if i.name.find("chara") == -1:
					continue
				i.get_node("spr").pause_mode = Node.PAUSE_MODE_PROCESS
				i.timer.pause_mode = Node.PAUSE_MODE_PROCESS
	else:
		map.get_tree().paused = false
		Engine.set_time_scale(spd)

func createItemButton(baseNode, bindInstance, text, callback, args=[], position = Vector2(90, 170), shortCut = null):
	var b = Button.new()
	b.rect_position = position
	b.text = text
	b.connect("pressed", bindInstance, callback, args)
	baseNode.add_child(b)
	if shortCut != null:
		if sys.main.keyboard == null:
			sys.main.reloadKey()
		sys.main.keyboard.connect(shortCut, self, callback, args)
	return b