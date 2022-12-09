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

var baseDic = {}

func resetData():
	if is_instance_valid(window):
		window.queue_free()
		taskBox = null
		window = null

func prepareData():
	if baseDic.empty():
		for i in utils.consts.itemsRare:
			utils.dicAppend(baseDic, "稀有", i)
		for i in utils.consts.medis + utils.consts.rareMedis:
			utils.dicAppend(baseDic, "药剂", i)
		for i in utils.consts.itemsSpecial:
			utils.dicAppend(baseDic, "特殊", i)

func createIllstrate():
	prepareData()

	window = WindowDialog.new()
	window.set_size(Vector2(600, 500))
	window.window_title = "道具图鉴"
	sys.main.get_node("ui").add_child(window)

	var tab = TabContainer.new()
	tab.margin_left = 40
	tab.margin_top = 20
	window.add_child(tab)
	for i in baseDic.keys():
		createTab(tab, i, baseDic.get(i))

func createTab(tab, key, ids = []):
	var container = utils.createScrollContainer(tab, Vector2(500, 400), Vector2(30, 30))
	container.name = key

	var context = utils.createGridContainer(container, 8)
	for i in ids:
		newItem(context, i)
	
func openIllstrate():
	if not is_instance_valid(window) or not window is WindowDialog:
		createIllstrate()
	window.popup_centered()

func newItem(node, id):
	var obj = preload("res://ui/item/item.tscn").instance()
	var items = sys.newItem(id)
	obj.init(items)
	obj.isDrag = false
	obj.rect_position = Vector2(40, 30)
	node.add_child(obj)
	