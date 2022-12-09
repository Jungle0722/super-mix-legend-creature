extends Node
func _ready():
	pass
func _init():
	call_deferred("init")
	pass
func _connect():
	pass
var utils = null
var azurCtrl = null
var base = null
var path = null
func init():
	if globalData.infoDs.has("g_ADDTALENT") || globalData.infoDs.has("g_quadruple_talent"):return

	if globalData.infoDs.has("g_azurlineBase"):
		base = globalData.infoDs["g_azurlineBase"]
		path = chaData.infoDs["cazurlineA"].dir
	if base != null:
		#初始化
		utils = globalData.infoDs["g_azurlineUtils"]
		azurCtrl = globalData.infoDs["g_azurline"]
		# azurCtrl.connect("onLoadGame",self,"gameCtrl")
		# azurCtrl.connect("manualLoadGame", self, "manualLoadGame")
		base.connect("onNewGame",self,"gameCtrl")
		base.loadSetting()
		azurCtrl.connect("resetData", self, "resetData")

func resetData():
	for i in talentSlot:
		i.queue_free()
	talentSlot.clear()
	readySlots.clear()

var talentSlot = []
var readySlots = []
func gameCtrl():
	if not talentSlot.empty():return
	var setting = base.getSetting("talentSetting", {"index":0,"size":8})
	if setting.size > 8:
		for i in range(setting.size - 8):
			var t = preload("res://ui/talentBtn/talentBtn.tscn").instance()
			t.name = "skill%d"%(i + 9)
			talentSlot.append(t)
			sys.main.playerPan.get_node("GridContainer").add_child(t)

		if not sys.main.player.is_connected("onPlusLv",self,"levelUp"):
			sys.main.player.connect("onPlusLv", self, "levelUp")

	if base.getSetting("clearMode", true):
		for i in sys.main.playerPan.get_node("GridContainer").get_children():
			if i.name.find("skill") > -1:
				utils.changeScript(i, sys.main.talentBtnScript)

func loadGame():
	gameCtrl()
	
# func manualLoadGame():
# 	loadData()
	# var originSlots = []
	# for i in sys.main.get_node("ui/player/GridContainer").get_children():
	# 	if i.name.find("skill") > -1:
	# 		originSlots.append(i)

	# var tmp2 = base.getData("talents", [])
	# var index = 0
	# for i in tmp2:
	# 	index += 1
	# 	var talent = talentData.infoDs.get(i)
	# 	var t = load("%s/%s/%s.gd" % [talent.dir, talent.id, talent.id]).new()
	# 	if index <= 8:
	# 		originSlots.pop_front().xueXi(t)	
	# 	else:
	# 		readySlots.pop_front().xueXi(t)		

# func loadTalents():
# 	var tmp = base.getData("talents", [])
# 	for i in tmp:
# 		var talent = talentData.infoDs.get(i)
# 		var t = load("%s/%s/%s.gd" % [talent.dir, talent.id, talent.id]).new()
# 		readySlots.pop_front().xueXi(t)

# func loadData():
# 	var setting = base.getSetting("talentSetting", {"index":0,"size":8})
# 	if setting.size == 8:return
# 	var diff = sys.main.player.lv - 8
# 	if diff <= 0:return
# 	for i in range(diff):
# 		if sys.main.player.talentDs.size() >= setting.size:break
# 		levelUp()

func levelUp():
	if sys.main.player.lv < 9 || talentSlot.empty():return
	var t = talentSlot.pop_front()
	t.setStage(1)
	if sys.main.player.lv == 15:
		var t2 = talentSlot.pop_front()
		t2.setStage(1)