extends Player
var utils = globalData.infoDs["g_azurlineUtils"]
var base = globalData.infoDs["g_azurlineBase"]
var gTalents = globalData.infoDs["g_azurlineTalents"]
var azurCtrl = globalData.infoDs["g_azurline"]
func _ready():
	upMaxEmp()
	call_deferred("playerInit")
	
func playerInit():
	pass

func infoGet():
	var items = []
	var cha1s = []
	var cha2s = []
	var tals = []
	
	# for i in self.items:
	# 	var dic = {
	# 		id = i.id
	# 	}
	# 	items.append(dic)
	
	for i in self.talentDs.values():
		var dic = {
			id = i.id, 
			lv = i.lv
		}
		tals.append(dic)
		
	var dic = {
		gold = gold, 
		renKou = renKou, 
		hp = hp, 
		lv = lv, 
		maxLv = maxLv, 
		emp = emp, 
		items = items, 
		tals = tals, 
		cha1s = cha1s, 
		cha2s = cha2s, 
		jlv = jinJieData.nowLv, 
		batLLv = sys.main.batLLv, 
		rndPoolRsl = chaData.rndPoolRsl, 
		itemRndPoolRsl = itemData.rndPoolRsl
	}
	return dic
	
func infoSet(dic):
	gold = dic["gold"]
	renKou = dic["renKou"]
	
	hp = dic["hp"]
	maxLv = dic["maxLv"]
	emp = dic["emp"]
	jinJieData.nowLv = dic["jlv"]
	sys.main.batLLv = dic["batLLv"]
	chaData.rndPoolRsl = dic["rndPoolRsl"]
	itemData.rndPoolRsl = dic["itemRndPoolRsl"]

	yield(sys.get_tree().create_timer(0.2), "timeout")
	gTalents.gameCtrl()	
	yield(sys.get_tree().create_timer(0.2), "timeout")
	
	for i in range(dic["lv"] - sys.main.player.lv):
		plusLv(1)

	for i in range(dic["tals"].size()):
		var tal = sys.newTalent(dic["tals"][i]["id"])
		tal.lv = dic["tals"][i]["lv"]
		sys.main.playerPan.get_node("GridContainer").get_child(i).xueXi(tal)
	
	sys.main.upLv()

func changeRenKou(n):
	pass

func getRenKou():
	return renKou + azurCtrl.checkPop()