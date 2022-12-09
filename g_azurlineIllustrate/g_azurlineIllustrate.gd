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
		research = globalData.infoDs["g_azurlineResearch"]
		azurCtrl = globalData.infoDs["g_azurline"]
		# azurCtrl.connect("initMainUI", self, "createIllstrate")
		azurCtrl.connect("resetData", self, "resetData")
		
# , "cex___alcamp-zeppelin2", "cex___alcamp-sandiego2", "cex___alcamp-merkuria2", "cex___alcamp-amagi2"
var baseCharaDic = {}

func resetData():
	if is_instance_valid(window):
		window.queue_free()
		taskBox = null
		window = null
var extraChas = ["cex___al-independence2"]
func prepareData():
	if baseCharaDic.empty():
		baseCharaDic["驱逐"] = ["cazurlineA"]
		baseCharaDic["轻巡"] = ["cazurlineB"]
		baseCharaDic["重巡"] = ["cazurlineC"]
		baseCharaDic["战列"] = ["cazurlineD"]
		baseCharaDic["航母"] = ["cazurlineE"]
		baseCharaDic["辅助"] = ["cazurlineF"]
		for i in utils.exLv4:
			var cha = sys.main.newChara(i)
			cha._extInit()
			utils.dicAppend(baseCharaDic, cha.get("camp"), cha.id)
			cha.queue_free()
		for i in research.config.charaData:
			var cha = sys.main.newChara(i + "2")
			cha._extInit()
			utils.dicAppend(baseCharaDic, cha.get("camp"), cha.id)
			cha.queue_free()
		for i in extraChas:
			var cha = sys.main.newChara(i)
			cha._extInit()
			utils.dicAppend(baseCharaDic, cha.get("camp"), cha.id)
			cha.queue_free()	
		
func createIllstrate():
	prepareData()
	window = utils.createWindowDialog(sys.main.get_node("ui"), "碧蓝航线图鉴", Vector2(1300, 800))

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
		if key == "高级塞壬":
			hBox1.set_custom_minimum_size(Vector2(300, 250))
		else:
			hBox1.set_custom_minimum_size(Vector2(200, 100))

		var chara = utils.newChara(i)
		chara._extInit()
		#2-4级单位总容器
		var hBox24 = HBoxContainer.new()
		hBox24.alignment = 1
		vbox.add_child(hBox24)
		# var achiChara = base.getSetting("achiChara", {})
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

				var c2 = utils.newChara(j)
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
						var c3 = utils.newChara(x)
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

	