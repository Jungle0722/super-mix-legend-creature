var buffName = "g_azurlineBase"
var test = false
var data = {}
var setting = {}
var saveData = {}
var file = File.new()
var utils

signal onPickCha    #选角色界面时发射信号
signal onPickItem   #选道具界面时发射信号
signal onNewGame    #初次进入游戏界面时发射信号
signal onLoadGame   #读取进入游戏界面时发射信号
signal onSaveGame   #点击保存并退出
signal onStartGame #onNewGame + onLoadGame
signal backTitle #返回标题页面
signal manualSaveGame

func getSetting(name, default = null):
	if setting == null:
		setting = {}
	var s = setting.get(name)
	if s == null && default != null:
		setSetting(name, default)
		s = default
	return s

func setSetting(name, value, save=true):
	setting[name] = value
	if save:
		saveSetting()

func getData(name, default = null):
	if data == null:
		data = {}
	var s = data.get(name)
	if s == null && default != null:
		setData(name, default)
		s = default
	return s

func setData(name, value):
	data[name] = value

func deleteSaveData():
	print("删除自动存档数据...")
	data = {}
	saveData()

# func addSaveData(name, value):
#     saveData[name] = value

# func getSaveData(name, default = null):
#     var s = saveData.get(name)
#     if s == null && default != null:
#         addSaveData(name, default)
#         s = default
#     return s

func _init():
	loadData()
	yield(sys.get_tree().create_timer(0.2), "timeout")
	sys.get_node("/root/Control/Panel2/Panel/Button").connect("pressed",self,"gameInit",["gameSet",true])
	# sys.get_node("/root/Control/Panel2/Panel/jiXuBtn").connect("pressed",self,"gameInit",["gameStart",false])
	call_deferred("baseInit")

func onJixuBtnPressed():
	sys.newBaseMsg("提示", "请开始新游戏后，通过控制面板-手动读档功能进行读档！")

func baseInit():
	utils = globalData.infoDs["g_azurlineUtils"]
	loadSetting()
	var jixuBtn = sys.get_node("/root/Control/Panel2/Panel/jiXuBtn")
	# jixuBtn.hide()

	var btn = Button.new()
	btn.rect_position = jixuBtn.rect_position
	btn.text = "继续游戏"
	btn.connect("pressed", self, "onJixuBtnPressed", [])

	sys.get_node("/root/Control/Panel2/Panel/jiXuBtn").replace_by(btn)
	var f = File.new()
	if f.open("user://data1/main.save", File.READ) == OK:
		btn.show()
	else:btn.hide()

func gameInit(name, sel):
	if name == "gameSet":
		call_deferred("gameSet")
	elif name == "gameStart":
		call_deferred("gameStart",sel)

func gameSet():
	sys.get_node("/root/topUi").get_children()[-1].connect("tree_exited",self,"gamePickCha")

func gamePickCha():
	if sys.has_node("../main"):
		sys.main.startMsg.get_node("btn_start").connect("button_down",self,"gamePickItem")
		emit_signal("onPickCha")

func gamePickItem():
	sys.get_node("/root/topUi/msgBaseX").get_node("btn_start").connect("button_down",self,"gameInit",["gameStart",true])
	emit_signal("onPickItem")

func gameStart(sel):
	loadSetting()
	emit_signal("onStartGame")
	if sel:
		emit_signal("onNewGame")
	else:
		emit_signal("onLoadGame")
	sys.main.connect("tree_exited",self,"gameExit")

# #打开选项菜单
# func openMenu():
# 	yield(sys.get_tree().create_timer(0.3), "timeout")
# 	sys.get_node("/root/topUi/option/VBoxContainer").get_node("tile").connect("button_down", self, "beforeSave")
#点击保存退出按钮
func azurSave():
	# #处理额外天赋
	# var waitDelTalents = []
	# var tmp = []
	# if sys.main.player.talentDs.size() > 8:
	# 	var index = 0
	# 	for i in sys.main.player.talentDs.keys():
	# 		index += 1
	# 		if index > 8:
	# 			waitDelTalents.append(i)
	
	# 	for i in waitDelTalents:
	# 		tmp.append(i)
	# 		if delTalents:
	# 			sys.main.player.talentDs.erase(i)
	# setData("talents", tmp)
	emit_signal("onSaveGame")
	yield(sys.get_tree().create_timer(2), "timeout")
	saveData()

func onBattleReady():
	if int(sys.main.guankaMsg.lvStep - 2) % 10 == 0:
		# autoSave()
		sys.main.saveInfoManual()
		saveData()
		print("自动存档成功！")
		# var sw = getSetting("saveWarn", false)
		# if sys.main.guankaMsg.lvStep - 2 < 15 and not sw:
		# 	sys.newBaseMsg("提示", "自动存档成功，请不要把角色放置在最左上角的格子(0, 0)，否则该角色有可能保存失败")
		# 	setSetting("saveWarn", true)

#自动存档
func autoSave():
	pass
	# var tmp2 = []
	# for i in sys.main.player.talentDs.keys():
	# 	tmp2.append(i)
	# setData("talents", tmp2)
	# emit_signal("onSaveGame")
	# sys.main.saveInfo()
	# yield(sys.get_tree().create_timer(2), "timeout")
	# saveData()
	# beforeSave(false)
	# sys.main.get_node("ui/player/GridContainer").print_tree_pretty()

func gameExit():
	# saveData()
	emit_signal("backTitle")
	_init()

func loadData():
	if file.file_exists("user://data1/azurlineData.save"):
		file.open("user://data1/azurlineData.save", File.READ)
		if file.get_len() > 0:
			data = parse_json(file.get_line())
		file.close()

func saveData():
	file.open("user://data1/azurlineData.save", File.WRITE)
	file.store_line(to_json(data))
	file.close()
	# saveSetting()

func saveSetting():
	file.open("user://data1/azurlineSetting.save", File.WRITE)
	file.store_line(to_json(setting))
	file.close()

func loadSetting():
	if file.file_exists("user://data1/azurlineSetting.save"):
		file.open("user://data1/azurlineSetting.save", File.READ)
		if file.get_len() > 0:
			setting = parse_json(file.get_line())
		file.close()

func loadImg(path,imgPath) -> ImageTexture:
	var im = Image.new()
	var realPath = "%s/%s" % [path,imgPath]
	if not file.file_exists(realPath):return null
	im.load(realPath)
	var imt = ImageTexture.new()
	imt.create_from_image(im)
	return imt

func find_file(path:String, filter:Array, flip:bool = false) -> Array:
	var file_list = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				file_list += find_file(path + "/" + file_name, filter, flip)
			else:
				if flip:
					if not file_name.split(".")[-1] in filter:
						file_list.append(path + "/" + file_name)
				else:
					if file_name.split(".")[-1] in filter:
						file_list.append(path + "/" + file_name)
			file_name = dir.get_next()
	else:
		print("错误：查找路径"+ path +"时出错")
	return file_list

# .rndPool.items
# .infoDs
# sys
# config
# chaData
# itemData
# guanKaData
# jinJieData
# talentData
# globalData
# topUi
# audio
# godotsteam
# Control

# .import
# Images.xcassets
# core
# ex
# godotSteam
# mods
# res
# ui
