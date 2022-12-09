var base = null
var path = null
var azurCtrl
var utils
var Keyboard
func _ready():
	pass
func _init():
	call_deferred("azurlineInit")
	pass
func _connect():
	pass

func azurlineInit():
	if globalData.infoDs.has("g_azurlineBase"):
		base = globalData.infoDs["g_azurlineBase"]
		path = chaData.infoDs["cazurlineA"].dir
	if base != null:
		#初始化
		base.connect("onLoadGame",self,"loadGame")
		base.connect("onNewGame",self,"newGame")
		azurCtrl = globalData.infoDs["g_azurline"]
		utils = globalData.infoDs["g_azurlineUtils"]

func loadGame():
	gameCtrl()

func newGame():
	gameCtrl()

func gameCtrl():
	sys.main.connect("onBattleEnd", self, "onBattleEnd")
	sys.main.player.connect("onAddCha", self, "onAddCha")

	var btn2 = sys.main.get_node("ui/guanKa/Button")
	var sc2 = ShortCut.new()
	var key2 = InputEventKey.new() 
	key2.scancode = KEY_F
	sc2.set_shortcut(key2)
	btn2.shortcut = sc2

func onAddCha(cha):
	yield(sys.get_tree().create_timer(0.5), "timeout")
	charaSort()

func autoSort():
	#排序人物
	charaSort()
	#排序装备
	var items = []
	for i in sys.main.itemGrid.get_children():
		if i.item == null or not is_instance_valid(i.item):
			i.queue_free()
			continue
		items.append(i)
		sys.main.itemGrid.remove_child(i)
	items.sort_custom(self, "sortForItem")
	for i in items:
		if i.item.att != null:
			sys.main.itemGrid.add_child(i)
var enableSort = true
func charaSort():
	if not enableSort:return
	enableSort = false
	var btGrid = sys.main.btGrid.get_children()
	for i in sys.main.btGrid.get_children():
		if is_instance_valid(i) and i.get_children().size() != 0:
			var cha:Chara = i.get_child(0)
			if cha.get("deleting") != null:cha.deleting = true
			sys.main.btGrid.remove_child(i)
	
	var merchant = []
	var sureEvos = []
	var others = []
	for i in btGrid:
		if i.get_children().size() == 0:continue
		var cha:Chara = i.get_child(0)
		if azurCtrl.allAzurlineFlag and cha.get("tag") != "azurline":continue
		if cha.id == "cex___al-merchant":
			merchant.append(i)
		elif cha.sureEvo:
			sureEvos.append(i)
		else:
			others.append(i)
		if cha.get("deleting") != null:cha.deleting = false
		
	sureEvos.sort_custom(self, "sortForChara")
	others.sort_custom(self, "sortForChara")
	btGrid = merchant + sureEvos + others
	for i in btGrid:
		if i.get_parent() == null:
			sys.main.btGrid.add_child(i)
	yield(sys.get_tree().create_timer(1), "timeout")
	enableSort = true
	
func sortForChara(a, b):
	if a.get_children().size() == 0:return false
	if b.get_children().size() == 0:return false
	var cha1:Chara = a.get_child(0)
	var cha2:Chara = b.get_child(0)
	return cha1.lv > cha2.lv || cha1.lv == cha2.lv && cha1.id > cha2.id

func sortForItem(a, b):
	if a.item == null:return false
	if b.item == null:return true
	return a.item.id > b.item.id

func onBattleEnd():	
	yield(sys.get_tree().create_timer(0.3), "timeout")
	autoSort()

