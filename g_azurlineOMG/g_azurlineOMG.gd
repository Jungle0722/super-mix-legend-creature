var base = null
var path = null
var utils = null
var azurCtrl = null
var gSiren
var research
var relic
var buffName = "g_azurlineOMG"
func _ready():
	pass
func _init():
	call_deferred("omgInit")
	pass
func _connect():
	pass

func omgInit():
	if globalData.infoDs.has("g_azurlineBase"):
		base = globalData.infoDs["g_azurlineBase"]
		path = chaData.infoDs["cazurlineA"].dir
	if base != null:
		#初始化
		utils = globalData.infoDs["g_azurlineUtils"]
		gSiren = globalData.infoDs["g_azurlineSiren"]
		research = globalData.infoDs["g_azurlineResearch"]
		azurCtrl = globalData.infoDs["g_azurline"]
		azurCtrl.connect("resetData", self, "resetData")
		base.connect("onNewGame",self,"gameCtrl")
		azurCtrl.connect("onLoadGame",self,"loadGame")
		relic = globalData.infoDs["g_azurlineRelic"]

		azurCtrl.connect("manualLoadGame", self, "loadGame")

func loadGame():
	var tmp = base.getData("omg", {})
	if not tmp.empty():
		planes = tmp["planes"]
		chasRndIds = tmp["chasRndIds"]
		skillRecord = tmp["skillRecord"]

func onSaveGame():
	var tmp = {}
	tmp["skillRecord"] = skillRecord
	tmp["planes"] = planes
	tmp["chasRndIds"] = chasRndIds
	base.setData("omg", tmp)
	research.onSaveGame()
		
func resetData():
	skillRecord = {}
	planes = {}
	chasRndIds = []

func gameCtrl():
	# sys.main.player.plusGold(950)
	# azurCtrl.pt = 1000
	yield(sys.get_tree().create_timer(1), "timeout")
	if azurCtrl.allAzurlineFlag:
		sys.main.connect("onEvo", self, "onEvo")
		
	if not azurCtrl.allAzurlineFlag or not sys.test:return
	
	sys.main.guankaMsg.lvStep = 70
	sys.main.batLLv = 1
	# gSiren.bossIndex = 0
	
	# sys.main.player.addCha(sys.main.newChara("cex___siren-cleaner"))
	# sys.main.player.addCha(sys.main.newChara("cex___siren-empres"))
	# var cha1 = sys.main.newChara("cex___al-commander4")
	# cha1.rank = 10
	# cha1.level = 4
	# sys.main.player.addCha(cha1)
	# cha1.awaken()

	sys.main.player.addCha(sys.main.newChara("cex___als-huteng2"))
	sys.main.player.addCha(sys.main.newChara("cazurlineE_4_3_1"))

	sys.main.player.addCha(sys.main.newChara("cex___alr-aijier2"))
	sys.main.player.addCha(sys.main.newChara("cex___alr-drake2"))
	sys.main.player.addCha(sys.main.newChara("cazurlineC_1_2_1"))
	sys.main.player.addCha(sys.main.newChara("cazurlineA_1_3_1"))
	sys.main.player.addCha(sys.main.newChara("cex___als-shengHei2"))
	
	sys.main.player.addCha(sys.main.newChara("cex___azurtoolmanHp"))
	sys.main.player.addCha(sys.main.newChara("cex___azurtoolmanHp"))
	sys.main.player.addCha(sys.main.newChara("cex___azurtoolman"))
	sys.main.player.addCha(sys.main.newChara("cex___azurtoolmanGM"))

	sys.main.player.addCha(sys.main.newChara("cex___als-aquila2"))
	sys.main.player.addCha(sys.main.newChara("cazurlineC_5_3_1"))
	var cha = sys.main.player.addCha(sys.main.newChara("cex___al-gaoxiong2"))
	cha.level = 19

	sys.main.player.addItem(sys.newItem("i_Hide_al_lightLance"))
	sys.main.player.addItem(sys.newItem("i_Hide_al_lightLance"))

	# for i in utils.getReadyChas():
	# 	if i.get("tag") != "azurline":
	# 		i.get_parent().queue_free()
	# 	else:
	# 		if i.has_method("upgrade"):
	# 			i.upgrade()

	utils.getRandomSkillBook()
	utils.getRandomSkillBook()
	utils.getSkillBook(16, 3)
	utils.getSkillBook(48, 3)
	utils.getSkillBook(49, 3)
	for i in range(3):
		# utils.getRandomSkillBook(1)
		# utils.getRandomSkillBook(2)
		# utils.getRandomSkillBook(3)
		var item = sys.newItem("i_Hide_plane")
		item.repair(true)
		sys.main.player.addItem(item)
		yield(sys.get_tree().create_timer(0.1), "timeout")
		pass

	sys.main.player.plusEmp(4000)
	sys.main.player.plusGold(9500)
	azurCtrl.pt = 10000
	gSiren.ticket += 10

	research.researchData = 10

	# var keyboard = utils.loadScript("Keyboard")
	# sys.main.get_node("ui").add_child(keyboard)
	sys.main.keyboard.connect("key_j", self, "test")
	sys.main.keyboard.connect("key_k", self, "test2")
	sys.main.keyboard.connect("key_l", self, "test3")

func test():
	pass

func test2():
	for i in utils.getAllCells(2):
		var cha = sys.main.matCha(i)
		if cha!=null && cha.team != 1 && cha.get("type") != "BOSS": 
			sys.main.delMatChara(cha)
	for i in range(5, 7):
		for j in range(0, 6):
			var cell = Vector2(i, j)
			var matcha = sys.main.matCha(cell)
			if matcha != null && matcha.get("type") != "BOSS":
				sys.main.delMatChara(matcha)
			var cha = sys.main.newChara("cex___azurtoolmanHp", 2)
			sys.main.map.add_child(cha)
			sys.main.setMatCha(cell, cha)

func test3():
	# var chara = sys.main.newChara("cex___azurtoolmanGM", 1)
	# sys.main.map.add_child(chara)
	# chara.isSumm = true
	# var achiChara = base.getSetting("achiChara", {})
	# for i in utils.exLv4:
	# 	var cha = sys.main.newChara(i)
	# 	cha._extInit()
	# 	var name = cha.chaName.rsplit("」")[1].rsplit("·")[0]
	# 	achiChara[i] = name
	# base.setSetting("achiChara", achiChara)
	
	var achiCamp = base.getSetting("achiCamp", [])
	if not achiCamp.has("cy"):
		achiCamp.append("cy")
	base.setSetting("achiCamp", achiCamp)

	var achiOther = base.getSetting("achiOther", [])
	if not achiOther.has("duShen"):
		achiOther.append("duShen")
	if not achiOther.has("researchEquip"):
		achiOther.append("researchEquip")
	if not achiOther.has("siren"):
		achiOther.append("siren")
	if not achiOther.has("warrior"):
		achiOther.append("warrior")
	base.setSetting("achiOther", achiOther)

func test4():
	sys.main.player.addCha(sys.main.newChara("cex___azurtoolman"))

	sys.main.player.addCha(sys.main.newChara("cex___almiu-akagi2"))
	sys.main.player.addCha(sys.main.newChara("cex___almiu-cleveland3"))
	sys.main.player.addCha(sys.main.newChara("cex___almiu-dido2"))
	sys.main.player.addCha(sys.main.newChara("cex___almiu-gascogne2"))

	sys.main.player.addItem(sys.newItem("i_Hide_al_jinGangZuan"))
	

#生成角色唯一ID
func generateChaId():
	var rid = sys.rndRan(10000, 99999)
	while chasRndIds.has(rid):
		rid = sys.rndRan(10000, 99999)
	chasRndIds.append(rid)
	return rid

var chasRndIds = []
var skillRecord = {}
var planes = {}
#进化时额外获得角色
func additionChara(evoCha):
	var baseRnd = 12
	if evoCha.chaName.find("指挥官") > -1 or evoCha.supportSpecEvo > 0:return

	if sys.rndPer(int(baseRnd/evoCha.lv)):
		print("触发进化额外获得角色成功!" + evoCha.chaName)
		sys.main.player.addCha(sys.main.newChara(evoCha.id))

#进化后归还药剂、飞机、技能书
func onEvo(evoCha):
	if evoCha.get("tag") != "azurline":return

	if relic.evoFlag and evoCha.team == 1:
		additionChara(evoCha)
