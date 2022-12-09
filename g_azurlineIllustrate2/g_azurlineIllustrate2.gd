extends Node
func _ready():
	pass
func _init():
	call_deferred("init")
func _connect():
	pass
var utils = null
var azurCtrl = null
var base = null
var path = null
var window
var context
var taskBox
var research
func init():
	if globalData.infoDs.has("g_azurlineBase"):
		base = globalData.infoDs["g_azurlineBase"]
		path = chaData.infoDs["cazurlineA"].dir
	if base != null:
		#初始化
		utils = globalData.infoDs["g_azurlineUtils"]
		azurCtrl = globalData.infoDs["g_azurline"]
		research = globalData.infoDs["g_azurlineResearch"]
		# azurCtrl.connect("initMainUI", self, "createIllstrate")
		azurCtrl.connect("resetData", self, "resetData")

var baseCharaDic = {
	"限定建造":[],
	"μ兵装":["cex___almiu-akagi2", "cex___almiu-cleveland3", "cex___almiu-hipper2", "cex___almiu-gascogne2", "cex___almiu-illustrious2", "cex___almiu-malin2", "cex___almiu-roonm2",
			"cex___almiu-taiho2", "cex___almiu-dido2", "cex___almiu-tashkent2"],
	"特殊":["cex___al-warspite", "cex___al-purin2", "cex___al-mingShi", "cex___al-ayanami3", "cex___al-independence2"],
	"塞壬-可获得":["cex___al-gaoxiong2", "cex___al-purifier2", "cex___al-qiye2", "cex___al-tester2", "cex___al-testerb2", "cex___al-weaveDream2", "cex___al-intruder2", "cex___al-intruder32",
			"cex___al-fangzhou2", "cex___al-feilong2", "cex___al-executer-a2", "cex___al-executer-b2", "cex___al-executer-c2", "cex___al-executer-d2"],
	"普通塞壬":["cex___siren-explorer3", "cex___siren-hunter3", "cex___siren-chess3", "cex___siren-breaker3", "cex___siren-seaLeader3"],
	"高级塞壬":["cex___siren-builder", "cex___siren-cleaner", "cex___siren-empres", "cex___siren-gaoxiong", "cex___siren-intruder", "cex___siren-intruder3", "cex___siren-purifier", 
			"cex___siren-qiye", "cex___siren-tester", "cex___siren-tester2", "cex___siren-weaveDream", "cex___siren-temparans", "cex___siren-strength", "cex___siren-hermit",
		"cex___siren-executer-a", "cex___siren-executer-b", "cex___siren-executer-c", "cex___siren-executer-d", "cex___siren-fangzhou", "cex___siren-feilong"],
	"随机事件":["cex___alhide-honoka2", "cex___alhide-marierose2", "cex___alhide-monica2", "cex___alhide-nagisa2"],
	"觉醒": ["cex___alawaken-A311", "cex___alawaken-C211", "cex___alawaken-D421", "cex___alawaken-E211", "cex___alawaken-warspite", "cex___al-indianapolis2", "cex___alawaken-B221", 
		"cex___alawaken-C311", "cex___alawaken-kii", "cex___alawaken-ayanami", "cex___alawaken-A211", "cex___alawaken-U37", "cex___alawaken-F111", "cex___alawaken-F121",
		"cex___alawaken-B311", "cex___alawaken-B321", "cex___alawaken-A411", "cex___alawaken-C411", "cex___alawaken-C521", "cex___alawaken-F311", "cex___alawaken-F321"],
}


func resetData():
	if is_instance_valid(window):
		window.queue_free()
		taskBox = null
		window = null

func prepareData():
	if baseCharaDic.get("限定建造").empty():
		for i in utils.specChasAll:
			utils.dicAppend(baseCharaDic, "限定建造", i.id + "2")
		for i in utils.consts.relicChas:
			utils.dicAppend(baseCharaDic, "遗物", i.objId + "2")
		for i in azurCtrl.gResearch.config.charaData:
			utils.dicAppend(baseCharaDic, "科研", i + "2")
		for i in utils.consts.subMarines:
			utils.dicAppend(baseCharaDic, "潜艇", i)

func createIllstrate():
	prepareData()
	window = WindowDialog.new()
	window.set_size(Vector2(1300, 800))
	window.window_title = "角色图鉴"
	sys.main.get_node("ui").add_child(window)

	var tab = TabContainer.new()
	tab.margin_left = 40
	tab.margin_top = 20
	window.add_child(tab)
	for i in baseCharaDic.keys():
		createTab(tab, i, baseCharaDic.get(i))

func createTab(tab, key, baseId = []):
	var context = utils.createScrollContainer(tab, Vector2(1200, 700), Vector2(30, 30))
	context.name = key
	taskBox = GridContainer.new()
	taskBox.columns = 6
	context.add_child(taskBox)
	for i in baseId:
		#种族级容器
		var vbox = VBoxContainer.new()
		taskBox.add_child(vbox)
		#放入基础单位
		var hBox1 = HBoxContainer.new()
		hBox1.alignment = 1
		vbox.add_child(hBox1)
		newChaBt(hBox1, i)
		hBox1.set_custom_minimum_size(Vector2(200, 100))

		var chara = sys.main.newChara(i)
		chara._extInit()
		#2-4级单位总容器
		var hBox24 = HBoxContainer.new()
		hBox24.alignment = 1
		vbox.add_child(hBox24)
		# var achiChara = base.getSetting("achiChara", {})
		if key == "可觉醒" and i == "cazurlineC_3":continue
		if chara.evos.size() > 0 && chara.lv < 4:						
			#处理2级单位
			for j in chara.evos:
				#2-4级单位分容器
				var vBox3 = VBoxContainer.new()
				vBox3.alignment = 1
				hBox24.add_child(vBox3)

				#2级单位容器
				var hBox2 = HBoxContainer.new()
				hBox2.alignment = 1
				vBox3.add_child(hBox2)
				newChaBt(hBox2, j)

				var c2 = sys.main.newChara(j)
				c2._extInit()

				if c2.evos.size() > 0 and c2.lv < 4:
					#3级单位总容器
					var hBox33 = HBoxContainer.new()
					hBox33.alignment = 1
					vBox3.add_child(hBox33)

					#处理3级单位
					for x in c2.evos:
						#3-4级单位分容器
						var vBox34 = VBoxContainer.new()
						vBox34.alignment = 1
						hBox33.add_child(vBox34)

						#3级单位容器
						var hBox3 = HBoxContainer.new()
						hBox3.alignment = 1
						vBox34.add_child(hBox3)
						newChaBt(hBox3, x)
						var c3 = sys.main.newChara(x)
						c3._extInit()
						if c3.evos.size() > 0 and c3.lv < 4:
							for y in c3.evos:
								#4级单位容器
								var hBox4 = HBoxContainer.new()
								hBox4.alignment = 1
								vBox34.add_child(hBox4)
								newChaBt(hBox4, y)
								hBox4.set_custom_minimum_size(Vector2(200, 100))
	
func openIllstrate():
	if not is_instance_valid(window) or not window is WindowDialog:
		createIllstrate()
	window.popup_centered()

func newChaBt(node, id):
	var chaBt = preload("res://ui/itemBt/itemBt.tscn").instance()
	chaBt.id = id
	node.add_child(chaBt)

	