extends Node
func _ready():
	pass
func _init():
	call_deferred("alInit")
func _connect():
	pass
var utils = null
var azurCtrl = null
var base = null
var path = null
var flag
var relic
var difficult
var shop
var siren
func alInit():
	if globalData.infoDs.has("g_azurlineBase"):
		base = globalData.infoDs["g_azurlineBase"]
		path = chaData.infoDs["cazurlineA"].dir
	if base != null:
		#初始化
		utils = globalData.infoDs["g_azurlineUtils"]
		azurCtrl = globalData.infoDs["g_azurline"]
		base.connect("onStartGame",self,"gameCtrl")
		# azurCtrl.connect("resetData", self, "resetData")
		azurCtrl.connect("initMainUI", self, "buildEventUI")
		relic = globalData.infoDs["g_azurlineRelic"]
		difficult = globalData.infoDs["g_azurlineDifficult"]
		shop = globalData.infoDs["g_azurlineShop"]
		siren = globalData.infoDs["g_azurlineSiren"]

func gameCtrl():
	sys.main.connect("onBattleStart",self,"onBattleStart")

func resetData():
	pass

var rndEvents = [1, 3, 6, 7, 8]
#创世难度专属事件
var diffEvents = [9, 10]
func onBattleReady():
	if not azurCtrl.allAzurlineFlag:return
	freeBtn()

	var num = sys.rndRan(1, 100)
	if num <= 2:
		call("buildEvent_%d"%sys.rndListItem(rndEvents))
	elif num <= 3 and difficult.difficult == 7 and difficult.step >= 40:
		call("buildEvent_%d"%sys.rndListItem(diffEvents))
	elif num <= 2 and difficult.step >= 81 and sys.main.batType != 2 and not siren.fuLiGuanFlag:
		#塞壬巡逻舰队
		call("buildEvent_11")
		
	if eventId != null:
		openEventUI()

func onBattleStart():
	if flag == "choose1_2":
		for i in utils.getAllChas(2):
			i.addBuff(utils.buffs.b_atkR.new(-3))
	if flag == "choose3_1":
		for i in utils.getAllChas(2):
			i.addBuff(utils.buffs.b_spd.new(10))
		for i in utils.getAllChas(1):
			i.addBuff(utils.buffs.b_spd.new(8))
	if flag == "choose3_2":
		for i in utils.getAllChas(2):
			i.addBuff(utils.buffs.b_cd.new(10))
		for i in utils.getAllChas(1):
			i.addBuff(utils.buffs.b_cd.new(8))
	flag = null

var window
var context
var btn1
var btn2
var eventId

var windowSize = Vector2(900, 500)

func openEventUI():
	window.popup_centered()

func buildEventUI():
	window = WindowDialog.new()
	window.set_size(windowSize)
	window.window_title = "突发事件"
	window.popup_exclusive = true
	window.get_close_button().hide()
	sys.main.get_node("ui").add_child(window)

	context = ScrollContainer.new()
	context.set_custom_minimum_size(windowSize)
	context.rect_position = Vector2(50, 50)
	context.set_margin(0, 50)
	window.add_child(context)

	utils.createRichTextLabel("", context, Vector2(700, 350))

#风暴
func buildEvent_1():
	eventId = 1
	context.get_node("RichTextLabel").bbcode_text = "观察员报告舰队前方有强烈的风暴，下一场战斗我方造成的伤害降低30%\n[color=#DC143C]绕过去[/color]：损失30金燃料费以消除负面影响"
	btn1 = createItemButton(window, "绕过去", "pressed1", Vector2(300, 350))
	btn2 = createItemButton(window, "硬闯", "pressed2", Vector2(400, 350))
	flag = "choose1_2"
func choose1(p):
	if p.index == 1:
		sys.main.player.plusGold(-30)
		flag = ""

#冷却或攻速
func buildEvent_3():
	eventId = 3
	context.get_node("RichTextLabel").bbcode_text = "一种神秘的音乐回荡在整片海域，所有听到它的人都不由自主的变得兴奋异常，敌方受到的影响略微更小\n[color=#DC143C]攻速[/color]：下回合所有人提高100%攻速\n[color=#DC143C]冷却[/color]：下回合所有人提高100%冷却速度"
	btn1 = createItemButton(window, "攻速", "pressed1", Vector2(300, 350))
	btn2 = createItemButton(window, "冷却", "pressed2", Vector2(400, 350))
func choose3(p):
	flag = "choose3_%d"%p.index

#理财事件：正面
func buildEvent_4():
	eventId = 4
	context.get_node("RichTextLabel").bbcode_text = "随着前线捷报频传，国际经济形势一片大好，存款升值25%！"
	btn1 = createItemButton(window, "知道了", "pressed1", Vector2(300, 350))
	azurCtrl.deposit *= 1.25

#理财事件：负面
func buildEvent_5():
	eventId = 5
	context.get_node("RichTextLabel").bbcode_text = "金库被神秘人光顾，存款损失10%！"
	btn1 = createItemButton(window, "知道了", "pressed1", Vector2(300, 350))
	azurCtrl.deposit *= 0.9
#兑换PT事件
func buildEvent_6():
	if sys.main.player.gold < 100:return
	eventId = 6
	var p1 = sys.rndRan(15, 22)/10.0
	var p2 = sys.rndRan(200, max(201, int(sys.main.player.gold)))
	context.get_node("RichTextLabel").bbcode_text = "一位急需金币的指挥官联系你，表示愿用{0}的比例用PT点数向你兑换{1}金币".format({"0":p1, "1":p2})
	btn1 = createItemButton(window, "同意", "pressed1", Vector2(300, 350), [{"a":p1, "b":p2}])
	btn2 = createItemButton(window, "拒绝", "pressed2", Vector2(400, 350))
func choose6(p):
	if p.index == 1:
		sys.main.player.plusGold(-p.param.b)
		azurCtrl.pt += int(p.param.b/p.param.a)

#书籍商人
func buildEvent_7():
	eventId = 7
	var p = sys.rndRan(20, 200)
	context.get_node("RichTextLabel").bbcode_text = "你遇到了一位书籍商人，他愿意以{0}金的价格卖你一本3级技能书".format({"0":p})
	btn1 = createItemButton(window, "同意", "pressed1", Vector2(300, 350), [{"a":p}])
	btn2 = createItemButton(window, "拒绝", "pressed2", Vector2(400, 350))
func choose7(p):
	if p.index == 1:
		sys.main.player.plusGold(-p.param.a)
		utils.getRandomSkillBook(3)

#魔方商人
func buildEvent_8():
	eventId = 8
	var p = sys.rndRan(200, 600)
	context.get_node("RichTextLabel").bbcode_text = "你遇到了一位神秘商人，他愿意以{0}金的价格卖你一颗心智魔方".format({"0":p})
	btn1 = createItemButton(window, "同意", "pressed1", Vector2(300, 350), [{"a":p}])
	btn2 = createItemButton(window, "拒绝", "pressed2", Vector2(400, 350))
func choose8(p):
	if p.index == 1:
		sys.main.player.plusGold(-p.param.a)
		sys.main.player.addItem(sys.newItem("i_Hide_al_mindcube"))

#仓库失火
func buildEvent_9():
	eventId = 9
	var p = int(sys.main.player.gold * 0.25)
	context.get_node("RichTextLabel").bbcode_text = "指挥官，昨夜仓库失火，损失高达{0}金币！".format({"0":p})
	btn1 = createItemButton(window, "知道了", "pressed1", Vector2(300, 350))
func choose9(p):
	if p.index == 1:
		sys.main.player.plusGold(-sys.main.player.gold * 0.25)
#汇率波动
func buildEvent_10():
	eventId = 10
	context.get_node("RichTextLabel").bbcode_text = "国际汇率波动，PT兑换比例上涨了0.5！"
	btn1 = createItemButton(window, "知道了", "pressed1", Vector2(300, 350))
func choose10(p):
	if p.index == 1:
		shop.ptRate += 0.5

#塞壬巡逻舰队
func buildEvent_11():
	eventId = 11
	context.get_node("RichTextLabel").bbcode_text = "指挥官，前方发现塞壬巡逻舰队！\n[color=#DC143C]迎战[/color]：所有敌方普通单位变为塞壬\n[color=#DC143C]撤退[/color]：损失20%PT点数"
	btn1 = createItemButton(window, "迎战", "pressed1", Vector2(300, 350))
	btn2 = createItemButton(window, "撤退", "pressed2", Vector2(400, 350))
func choose11(p):
	if p.index == 1:
		var chas = []
		for i in utils.getAllCells(2):
			var cha = sys.main.matCha(i)
			if cha != null and cha.team == 2:
				chas.append(cha)
		for i in chas:
			if i.get("type") == "BOSS":continue
			var cha = sys.main.newChara(sys.rndListItem(siren.leaders)%[3], 2)
			for j in i.items:
				cha.addItem(sys.newItem(j.id))
			var node = i.get_parent()
			i.remove()
			cha.isItem = i.isItem
			node.add_child(cha)
			cha.position = i.position
			cha.cell = i.cell
			cha.oldCell = i.oldCell
			cha.isDrag = i.isDrag
			if not i.isItem:
				sys.main.setMatCha(cha.cell, cha)
			difficult.doDiffBonus(cha)	
	else:
		azurCtrl.plusPt(azurCtrl.pt * -0.2)
		
#释放按钮
func freeBtn():
	if is_instance_valid(btn1):
		btn1.queue_free()
		btn1 = null
	if is_instance_valid(btn2):
		btn2.queue_free()
		btn2 = null

func pressed1(param = {}):
	pressed(1, param)
func pressed2(param = {}):
	pressed(2, param)
func pressed(index, param = {}):
	window.hide()
	var method = "choose%d"%eventId
	if self.has_method(method):
		call("choose%d"%eventId, {"index":index, "param":param})
	eventId = null

func createItemButton(baseNode, text, callback, position = Vector2(90, 170), args=[{}]):
	var b = Button.new()
	b.rect_position = position
	b.text = text
	b.connect("pressed", self, callback, args)
	baseNode.add_child(b)
	return b