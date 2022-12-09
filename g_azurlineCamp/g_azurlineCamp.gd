# extends Node
# func _ready():
# 	pass
# func _init():
# 	call_deferred("alInit")
# func _connect():
# 	pass
# var utils = null
# var azurCtrl = null
# var base = null
# var path = null
# var globalBonus
# var difficult
# var battle
# func alInit():
# 	if globalData.infoDs.has("g_azurlineBase"):
# 		base = globalData.infoDs["g_azurlineBase"]
# 		path = chaData.infoDs["cazurlineA"].dir
# 	if base != null:
# 		#初始化
# 		utils = globalData.infoDs["g_azurlineUtils"]
# 		azurCtrl = globalData.infoDs["g_azurline"]
# 		globalBonus = globalData.infoDs["g_azurlineGlobalBonus"]
# 		difficult = globalData.infoDs["g_azurlineDifficult"]
# 		battle = globalData.infoDs["g_azurlineBattle"]
# 		azurCtrl.connect("resetData", self, "resetData")
# 		base.connect("onNewGame",self,"newGame")

# func resetData():
# 	window = null
# 	favors = {}

# func newGame():
# 	sys.main.connect("onBattleEnd", self, "onBattleEnd")
# 	sys.main.connect("onBattleStart", self, "onBattleStart")
# 	initVars()

# func onBattleStart():
# 	refreshBouns()

# 	var camps = bonus.keys()
# 	camps.sort_custom(self, "sortByLv")
# 	camps.pop_back()
# 	camps.pop_back()
# 	for i in utils.getAllChas(2):
# 		i.addBuff(b_campBonus.new(camps))

# func sortByLv(a, b):
# 	return favorLevel.get(a) > favorLevel.get(b)

# func onBattleEnd():
# 	var statis = checkCharaCamp()
# 	for i in statis.keys():
# 		var num = max(1, int(statis.get(i) * 0.5))
# 		if battle.count > 0:
# 			num = max(1, num * 0.3)
# 		plusFavor(i, num)
# 	base.setSetting("favorLevel", favorLevel)

# func plusFavor(camp, num):
# 	initVars()
# 	utils.dicPlus(favors, camp, num)
# 	if favors.get(camp) >= 100 and favorLevel.get(camp) < 12:
# 		utils.dicPlus(favorLevel, camp, 1)
# 		utils.dicPlus(favors, camp, -100)
# 	if favors.get(camp) < 0 and favorLevel.get(camp) > 0:
# 		utils.dicPlus(favorLevel, camp, -1)
# 		favors[camp] = 0
# #随机变更某个阵营的好感度
# func changeRndFavor(num):
# 	var camp = sys.rndListItem(favors.keys())
# 	plusFavor(camp, num)
# 	return camp

# var window
# func open():
# 	if not is_instance_valid(window) or not window is WindowDialog:
# 		buildWindow()
# 	refreshLabel()
# 	window.popup_centered()

# func buildWindow():
# 	window = utils.createWindowDialog(sys.main.get_node("ui"), "阵营好感", Vector2(1100, 500))
# 	var context = utils.createScrollContainer(window, Vector2(1030, 350), Vector2(30, 100))
# 	context.name = "context"
# 	utils.createItemButton(window, self, "说明", "openHelp", [], Vector2(30, 30))

# 	var gridList = GridContainer.new()
# 	gridList.columns = 6
# 	gridList.name = "grid"
# 	context.add_child(gridList)
	
# 	initVars()
# 	loadContext()	

# func initVars():
# 	if favors.empty():
# 		for i in config.keys():
# 			favors[i] = 0

# 	if bonus.empty():
# 		for i in config.keys():
# 			bonus[i] = []
# 	var fl = base.getSetting("favorLevel", {})
# 	if fl.empty():
# 		for i in config.keys():
# 			favorLevel[i] = 0
# 		base.setSetting("favorLevel", favorLevel)
# 	else:
# 		favorLevel = fl

# var favors = {}
# var favorLevel = {}
# var bonus = {}
# var labels = {}
# func loadContext():
# 	var gridList = window.get_node("context/grid")
# 	for i in gridList.get_children():
# 		i.queue_free()

# 	utils.createRichTextLabel("[color=#BDB76B]阵营", gridList, Vector2(150, 50))
# 	utils.createRichTextLabel("[color=#BDB76B]好感度", gridList, Vector2(100, 50))
# 	utils.createRichTextLabel("[color=#BDB76B]等级", gridList, Vector2(100, 50))
# 	utils.createRichTextLabel("[color=#BDB76B]当前加成", gridList, Vector2(250, 50))
# 	utils.createRichTextLabel("[color=#BDB76B]专属角色", gridList, Vector2(150, 50))
# 	utils.createRichTextLabel("[color=#BDB76B]操作", gridList, Vector2(100, 50))
# 	for i in config.keys():
# 		labels[i] = []
# 		utils.createRichTextLabel(i, gridList, Vector2(100, 50))
# 		#好感
# 		var lb1 = utils.createRichTextLabel("%d/100"%favors.get(i), gridList, Vector2(100, 50))
# 		#好感等级
# 		var lb2 = utils.createRichTextLabel(String(favorLevel.get(i)), gridList, Vector2(100, 50))
# 		#加成
# 		var lb3 = utils.createRichTextLabel(getBounsText(i), gridList, Vector2(250, 50))
# 		labels[i].append(lb1)
# 		labels[i].append(lb2)
# 		labels[i].append(lb3)

# 		var conf = config.get(i)
# 		utils.createRichTextLabel(conf.name, gridList, Vector2(200, 50))
# 		var hbox = utils.createHBox(gridList)
# 		utils.createItemButton(hbox, self, "查看", "showCha", [i, conf])
# 		utils.createItemButton(hbox, self, "兑换", "getChara", [i, conf])

# func refreshLabel():
# 	for i in labels.keys():
# 		var lbs = labels.get(i)
# 		lbs[0].bbcode_text = "[color=#DC143C]%d/100"%favors.get(i)
# 		lbs[1].bbcode_text = String(favorLevel.get(i))
# 		lbs[2].bbcode_text = getBounsText(i)
# #将角色阵营转化为大阵营
# func convertCharaCamp(camp):
# 	return relationMap.get(camp)
# #统计角色大阵营
# func checkCharaCamp():
# 	var statis = {}
# 	for i in utils.getAllChas(2):
# 		if i.get("camp") == null or i.get("tag") != "azurline" or i.lv < 4:continue
# 		utils.dicPlus(statis, convertCharaCamp(i.get("camp")), 1)
# 	return statis

# var bossWindow
# var chaContainer
# func showCha(name, conf):
# 	if not is_instance_valid(bossWindow):
# 		bossWindow = utils.createWindowDialog(sys.main.get_node("ui"), "角色信息", Vector2(600, 400))
# 		chaContainer = CenterContainer.new()
# 		chaContainer.set_custom_minimum_size(Vector2(550, 380))
# 		bossWindow.add_child(chaContainer)
# 	for i in chaContainer.get_children():
# 		i.queue_free()
# 	var chaBt = preload("res://ui/itemBt/itemBt.tscn").instance()
# 	chaBt.id = conf.objId + "2"
# 	chaContainer.add_child(chaBt)
# 	bossWindow.popup_centered()

# func getChara(name, conf):
# 	var statis = checkCharaCamp()
# 	if favorLevel.get(name) < 10:
# 		sys.newBaseMsg("兑换失败", "该阵营好感等级不足")
# 		return
# 	if utils.dicGet(statis, name, 0) < 3:
# 		sys.newBaseMsg("兑换失败", "我方场上该阵营传奇角色小于3个")
# 		return
# 	utils.dicPlus(favorLevel, name, -1)
# 	base.setSetting("favorLevel", favorLevel)
# 	sys.main.player.addCha(sys.main.newChara(conf.objId))

# var relationMap = {
# 	"重樱":"重樱群岛",
# 	"白鹰":"碧蓝航线",
# 	"皇家":"大西洋宪章",
# 	"铁血":"赤色中轴",
# 	"北方联合":"大西洋宪章",
# 	"自由鸢尾":"大西洋宪章",
# 	"其他":"碧蓝航线",
# 	"塞壬":"赤色中轴"
# }	
# func refreshBouns():
# 	initVars()
# 	var step = difficult.step
# 	for i in bonus.keys():
# 		match i:
# 			"重樱群岛":
# 				bonus.get(i).clear()
# 				#法强
# 				bonus.get(i).append(bonusCalcul(favorLevel.get(i) * step / 50.0))
# 			"大西洋宪章":
# 				bonus.get(i).clear()
# 				#攻击
# 				bonus.get(i).append(bonusCalcul(favorLevel.get(i) * step / 50.0))
# 			"碧蓝航线":
# 				bonus.get(i).clear()
# 				#双速
# 				bonus.get(i).append(bonusCalcul(favorLevel.get(i) * step / 50.0))
# 				bonus.get(i).append(bonusCalcul(favorLevel.get(i) * step / 50.0))
# 			"赤色中轴":
# 				bonus.get(i).clear()
# 				#血量
# 				bonus.get(i).append(bonusCalcul(favorLevel.get(i) * step / 50.0))
# 				#双防
# 				bonus.get(i).append(bonusCalcul(favorLevel.get(i) * step / 50.0))
# 				#闪避
# 				bonus.get(i).append(bonusCalcul(favorLevel.get(i) * step / 50.0))
# #处理加成
# func bonusCalcul(num):
# 	return min(30, utils.floatScale(num))

# func getBounsText(camp):
# 	refreshBouns()
# 	match camp:
# 		"重樱群岛":return "法强([color=#DC143C]{1}%[/color])".format({"1":bonus.get(camp)[0]})
# 		"大西洋宪章":return "攻击([color=#DC143C]{1}%[/color])".format({"1":bonus.get(camp)[0]})
# 		"碧蓝航线":return "攻速 冷却([color=#DC143C]{1}%[/color])".format({"1":bonus.get(camp)[0]})
# 		"赤色中轴":return "血量 双防 闪避([color=#DC143C]{1}%[/color])".format({"1":bonus.get(camp)[0]})

# #创建角色实例
# func createCharaIns(node, id):
# 	var chaBt = preload("res://ui/itemBt/itemBt.tscn").instance()
# 	chaBt.id = id
# 	node.add_child(chaBt)

# var config = {
# 	"重樱群岛":{
# 		"objId":"cex___alcamp-amagi",
# 		"name":"天城",
# 	},
# 	"大西洋宪章":{
# 		"objId":"cex___alcamp-merkuria",
# 		"name":"水星纪念",
# 	},
# 	"碧蓝航线":{
# 		"objId":"cex___alcamp-sandiego",
# 		"name":"圣地亚哥",
# 	},
# 	"赤色中轴":{
# 		"objId":"cex___alcamp-zeppelin",
# 		"name":"齐柏林伯爵",
# 	},
# }


# var shopGuideText = """
# [color=#BDB76B]好感度：[/color]
# 游戏中，使用每个阵营的传奇角色战斗，均会增加对应的好感度，好感度每局游戏结束时会清零
# 阵营关系如下：
# 重樱群岛：  重樱
# 大西洋宪章：皇家 北方联合 自由鸢尾
# 碧蓝航线：	白鹰 其他
# 赤色中轴：  铁血 塞壬
# [color=#BDB76B]好感等级：[/color]
# 每100点对应好感度提升1级，好感等级可以提升对应的属性加成，解锁该阵营专属角色
# 好感等级每局游戏结束时[color=#DC143C]不会清零[/color]，最多12级
# [color=#BDB76B]专属角色：[/color]
# 好感等级达到10级时解锁兑换资格
# 场上超过(含)3个该阵营传奇角色时，可兑换，兑换后该阵营好感等级降低1级
# [color=#BDB76B]属性加成：[/color]
# 每个阵营均提供不同的属性加成，属性加成对我方所有角色生效
# 属性加成和该阵营好感等级、当前层数有关
# 好感等级最低的两个阵营，其加成不生效！
# """

# func openHelp():
# 	utils.openHelpWindow(shopGuideText)

# class b_campBonus:
# 	extends Buff
# 	var camp = globalData.infoDs.get("g_azurlineCamp")
# 	var camps = camps
# 	func _init(camps):
# 		attInit()
# 		id = "b_campBonus"
# 		self.camps = camps
# 	func _connect():
# 		if camps.has("重樱群岛"):
# 			att.mgiAtkL = camp.bonus.get("重樱群岛")[0] / 100.0
# 		if camps.has("大西洋宪章"):
# 			att.atkL = camp.bonus.get("大西洋宪章")[0] / 100.0
# 		if camps.has("碧蓝航线"):
# 			att.cd = camp.bonus.get("碧蓝航线")[0] / 100.0
# 			att.spd = camp.bonus.get("碧蓝航线")[1] / 100.0
# 		if camps.has("赤色中轴"):
# 			att.maxHpL = camp.bonus.get("赤色中轴")[0] / 100.0
# 			att.defL = camp.bonus.get("赤色中轴")[1] / 100.0
# 			att.mgiDefL = camp.bonus.get("赤色中轴")[1] / 100.0
# 			att.dod = camp.bonus.get("赤色中轴")[2] / 100.0