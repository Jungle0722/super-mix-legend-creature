extends "../cex___warship/cex___warship.gd"
func _info():
	pass
var inited = false
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "小卖部"  #角色的名称
	attCoe.atkRan = 1  #攻击距离
	attCoe.maxHp = 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 0     #攻击力（每点代表8.5）
	attCoe.mgiAtk =0  #魔法攻击（每点代表13.7）
	attCoe.def = 0     #物理防御（每点代表15）
	attCoe.mgiDef = 0  #魔法防御（每点代表16.6）
	lv = 1             #等级的设置
	aiOn = false
	isDrag = false
	addSkillTxt("此单位不可参与战斗，为功能性NPC")
	addSkill("每回合开始时，会自动将身上的第一件装备随机替换成另一件装备，并强制扣除15金币，若放入技能书则换为另一本同稀有度技能书", "折旧换新")
	addSkill("放入一件装备(记为A)，再放入一件装备(记为B)，点击[装备熔炼]，\n将B的基础属性35%熔炼到A上(减伤、减冷却不会被熔炼)，一件装备最多熔炼3次，且熔炼过的装备不能作为B", "装备熔炼")
	addSkill("放入3架普通舰载机，获得一架随机稀有舰载机", "道具合成")
	addSkill("点击装备出售按钮，卖出身上的所有装备", "装备出售")
	addSkill("立即获得500金币与500PT，之后每回合扣除50金，直到还清（本金+300金利息）", "贷款")
	addSkillTxt("[color=#C0C0C0]当前未还贷款：%d[/color]"%[azurCtrl.loan])
	type = "npc"
	sacrifice = false
	if not inited:
		sys.main.connect("onBattleStart",self,"onBattleStart")
		sys.main.connect("onBattleEnd", self, "onBattleEnd")
		inited = true
		if not is_connected("onPressed", self, "chaInfo"):
			connect("onPressed", self, "chaInfo")
		if not is_connected("onAddItem", self, "onAddItem"):
			connect("onAddItem",self,"onAddItem")

var text2 = "[color=#C0C0C0]当前未还贷款：%d[/color]"

func onBattleEnd():
	if lotteryNum != null:
		lotteryIndex += 1
		if lotteryIndex == 5:
			var result = sys.rndRan(0, 99)
			if lotteryNum == result:
				sys.newBaseMsg("开奖结果", "本期彩票开奖结果为%d，恭喜你中了一等奖，奖励%dPT！"%[result, 1200 * relic.caiPiaoBonus])
				azurCtrl.plusPt(1200 * relic.caiPiaoBonus)
			elif abs(result - lotteryNum) <= 10:
				sys.newBaseMsg("开奖结果", "本期彩票开奖结果为%d，恭喜你中了二等奖，奖励%d金币！"%[result, 1200 * relic.caiPiaoBonus])
				sys.main.player.plusGold(1200 * relic.caiPiaoBonus)
			else:
				sys.newBaseMsg("开奖结果", "本期彩票开奖结果为%d，恭喜你中了参与奖，喜提%d金币巨款！"%[result, 1 * relic.caiPiaoBonus])
				sys.main.player.plusGold(1 * relic.caiPiaoBonus)
			lotteryIndex = 0
			lotteryNum = null

func onAddItem(item):
	var masCha = item.masCha
	if item.id == "i_Hide_al_agreedProof":
		agreedProof()
		return
	elif item.id == "i_Hide_al_knowledgeBook":
		openBookUI()
		return
	elif item.id == "i_Hide_al_directBox":
		directBox()
		return
	elif item.id == "i_Hide_al_directFlag":
		directFlag()
		return	
	elif item.id == "i_Hide_al_equipBox":
		equipBox()
		return
	elif item.id == "i_Hide_al_limitProof":
		limitProof()
		return
	elif item.id == "i_Hide_alrm_equipResearch":
		equipResearch(item)
		return
	if item.id == "i_Hide_plane":
		var n = 0
		for i in masCha.items:
			if  i.id == item.id:
				n += 1
		if n == 3:
			yield(sys.get_tree().create_timer(0.1), "timeout")
			if item.id == "i_Hide_plane":
				var it = sys.newItem("i_Hide_plane")
				it.repair(true)
				sys.main.player.addItem(it)
			var index = masCha.items.size() - 1
			while(index >= 0):
				var i = masCha.items[index]
				sys.main.player.delItem(i)
				index -= 1

func equipResearch(it):
	if it.equipId.find("alr_p") > -1:
		#飞机
		sys.main.player.addItem(sys.newItem(it.equipId))
		it.delSelf()
	else:
		if items[0] == it:
			it.delFromCha()
		elif items[0].id == "i_Hide_alrm_equipResearch":
			var arr = []
			for i in research.equipTemps:
				if i != it.equipId and i != items[0].equipId:
					arr.append(i)
			if arr.empty():
				it.delFromCha()
				items[0].delFromCha()
			else:
				var newId = sys.rndListItem(arr)
				var newEquip = sys.newItem("i_Hide_alrm_equipResearch")
				newEquip.repair(newId)
				sys.main.player.addItem(newEquip)
				it.delSelf()
				items[0].delSelf()
		else:
			var fuLiao = items[0]
			var equip = sys.newItem(it.equipId)
			research.rongHe(fuLiao, equip)
			sys.newBaseMsg("提示", "研发成功！")
			sys.main.player.addItem(equip)
			it.delSelf()
			items[0].delSelf()
						
func limitProof():
	if azurCtrl.upCha != null:
		sys.main.player.addCha(sys.main.newChara(azurCtrl.upCha))
		for i in items:
			if i.id == "i_Hide_al_limitProof":
				i.delSelf()

func onBattleStart():
	if sys.main.player.gold < 15:
		return
	if items.empty():return
	var it = items[0]
	if it.id == "i_Hide_plane" or it.get("itemTag") == "medic" or it.price == 0:
		return
	if it.get("itemTag") == "skillbook":
		utils.getRandomSkillBook(it.skill.rarity)
	else:
		sys.main.player.addItem(utils.getRndItem())
	sys.main.player.subGold(15)
	sys.main.player.delItem(it)

func chaInfo(cha):
	skillStrs[6] = text2%[azurCtrl.loan]
	yield(cha.reTimer(0.1),"timeout")
	var charaInfo = sys.get_node("/root/topUi/charaInfoMsg")
	var txt = charaInfo.get_node("txt")
	var split = txt.bbcode_text.rsplit("\n")
	var res = ""
	for i in range(split.size()):
		if i == 0:
			res += split[i] + "\n"
		elif i == 1:
			res += split[i] + "  闪避：{0}%  承疗：{rehp}%  治疗效果:{healHpL}%\n".format({"0":int(cha.att.dod*100), "rehp":int(cha.att.reHp*100), "healHpL":int((cha.healHpL+azurCtrl.healHpL)*100)})
		elif i == 2:
			res += split[i] + "  爆伤：{0}%\n".format({"0":int((cha.att.criR+2)*100)})
		elif i == 3:
			res += split[i] + "  攻速：{0}%\n".format({"0":int((cha.att.spd-1)*100)})
		elif i == 4:
			var d1 = int(cha.att.def / (100 + cha.att.def) * 100)
			var d2 = int(cha.att.mgiDef / (100 + cha.att.mgiDef) * 100)
			res += "物理防御：{0}({1}%)  魔法防御：{2}({3}%)".format({"0":int(cha.att.def),"1":d1,"2":int(cha.att.mgiDef),"3":d2})
	for i in skillStrs:
		var tmp = i.rsplit("{tmpName}")
		i = tmp[0]
		if tmp.size() == 2:
			var skName = tmp[1]
			var skData = skillData.get(skName)
			if skData != null:
				var cd = skData.get("cd")
				var id = skData.get("id")
				var sk
				if id != null:
					sk = getSkill(id)
				if sk != null:
					i = i.replace("{cd}", utils.floatScale(sk.cd/(1+att.cd)))
				var dmg = self.getSkillEffect(skName)
				if dmg != null:
					i = i.replace("{damage}", int(dmg))
		i = appendMeta(i)
		
		res += i + "\n"

	txt.bbcode_text = res
	utils.createItemButton(charaInfo, self, "贷款", "loan", [], Vector2(290, 600))
	var btnPos = Vector2(900, 600)

	btnPos.x += 110
	utils.createItemButton(charaInfo, self, "装备出售", "sellItems", [cha], btnPos)

	btnPos.x += 110
	utils.createItemButton(charaInfo, self, "装备熔炼", "synthesis", [cha], btnPos)

	if lotteryNum == null:
		btnPos.x += 110
		utils.createItemButton(charaInfo, self, "购买彩票", "lotteryUI", [], btnPos)

	charaInfo.get_node("Button").hide()

func loan():
	azurCtrl.doLoan()
	skillStrs[6] = text2%[azurCtrl.loan]	

#脱下装备
func removeAllEquip(cha):
	var index = cha.items.size()-1
	while index >= 0:
		cha.delItem(cha.items[index])
		index -= 1
#出售装备
func sellItems(cha):
	var index = cha.items.size()-1
	while index >= 0:
		var item = cha.items[index]
		sys.main.player.plusGold(item.price)
		sys.main.player.delItem(item)
		index -= 1
	
func synthesis(cha):
	var itemList = cha.items
	if itemList.size() < 2:return
	var a = itemList[0]
	var b = itemList[1]

	if a.get("tag") != "azurline" or b.get("tag") != "azurline":
		sys.newBaseMsg("错误", "非碧蓝航线装备无法进行熔炼！")
		return
	# if a.ronglian >= 1 + relic.addiRongLian:
	# 	sys.newBaseMsg("错误", "一件装备最多熔炼%d次"%[1 + relic.addiRongLian])
	# 	return	
	# if b.ronglian > 0:
	# 	sys.newBaseMsg("错误", "熔炼过的装备无法作为被熔炼素材")
	# 	return	

	sys.main.player.plusGold(10000)
	azurCtrl.plusPt(10000)
	var newEquip = sys.newItem("i_Hide_al_equipBox")
	sys.main.player.addItem(newEquip)
	var p = 1 + a.ronglian
	a.att.maxHp += b.att.maxHp*p
	a.att.maxHpL += b.att.maxHpL*p
	a.att.atk += b.att.atk*p
	a.att.atkL += b.att.atkL*p
	a.att.mgiAtk += b.att.mgiAtk*p
	a.att.mgiAtkL += b.att.mgiAtkL*p
	a.att.atkRan += b.att.atkRan*p
	a.att.def += b.att.def*p
	a.att.mgiDef += b.att.mgiDef*p
	a.att.pen += b.att.pen*p
	a.att.mgiPen += b.att.mgiPen*p
	a.att.cri += b.att.cri*p
	a.att.criR += b.att.criR*p
	a.att.suck += b.att.suck*p
	a.att.mgiSuck += b.att.mgiSuck*p
	a.att.reHp += b.att.reHp*p
	a.att.cd += b.att.cd*p
	a.att.spd += b.att.spd*p
	a.att.dod += b.att.dod*p
	a.att.atkR += b.att.atkR*p
	a.att.penL += b.att.penL*p
	a.att.mgiPenL += b.att.mgiPenL*p
	sys.main.player.delItem(b)
	a.ronglian += 1

######################################知识之书##############################
var tmpSkOpt = []
func openBookUI():
	var selSkWindow = utils.createWindowDialog(sys.main.get_node("ui"), "技能选择", Vector2(1150, 600))
	selSkWindow.popup_exclusive = true
	selSkWindow.get_close_button().hide()
	var statisScroll = utils.createScrollContainer(selSkWindow, Vector2(1100, 550), Vector2(10, 10))
	statisScroll.margin_top = 20
	statisScroll.margin_left = 30
	var context = utils.createVBox(statisScroll)
	context.margin_top = 50
	context.margin_left = 50
	var sks = []
	if tmpSkOpt.empty():
		for i in range(10):
			var sk = skillPool.getRandomSkill(3)
			while sks.has(sk.sid):
				sk = skillPool.getRandomSkill(3)
			sks.append(sk.sid)
			tmpSkOpt.append(sk)
	for i in range(10):
		var hbox = utils.createHBox(context)
		var sk = tmpSkOpt[i]
		utils.createRichTextLabel(utils.consts.colorGold + "[{1}]:{3}".format({"1":sk.sname,"3":sk.text}), hbox, Vector2(1000, 50))
		utils.createItemButton(hbox, self, "选择", "doLearnSkill", [sk, selSkWindow])
	selSkWindow.popup_centered()
func doLearnSkill(sk, selSkWindow):
	tmpSkOpt.clear()
	selSkWindow.hide()
	selSkWindow.queue_free()
	utils.getSkillBook(sk.sid, 3)
	for i in items:
		if i.id == "i_Hide_al_knowledgeBook":
			sys.main.player.delItem(i)
######################################约定的证明##############################
#约定的证明
func agreedProof():
	var specChaWindow = utils.createWindowDialog(sys.main.get_node("ui"), "特殊池角色", Vector2(620, 800))
	var context = utils.createScrollContainer(specChaWindow, Vector2(550, 720), Vector2(30, 50))
	specChaWindow.popup_exclusive = true
	specChaWindow.get_close_button().hide()

	var taskBox = utils.createGridContainer(context, 3)
	taskBox.rect_position = Vector2(50,50)
	taskBox.set_custom_minimum_size(Vector2(550, 750))

	for i in utils.specChas:
		utils.createRichTextLabel(utils.consts.colorRed + i.name, taskBox, Vector2(400, 50))
		utils.createItemButton(taskBox, self, "选择", "doGetSpecCha", [i, specChaWindow])
		utils.createItemButton(taskBox, self, "查看", "viewSpecCha", [i])
	specChaWindow.popup_centered()
var bossWindow
var chaContainer
func viewSpecCha(conf):
	if not is_instance_valid(bossWindow):
		bossWindow = utils.createWindowDialog(sys.main.get_node("ui"), "目标信息", Vector2(600, 400))
		chaContainer = CenterContainer.new()
		chaContainer.set_custom_minimum_size(Vector2(550, 380))
		bossWindow.add_child(chaContainer)
	for i in chaContainer.get_children():
		i.queue_free()
	var chaBt = preload("res://ui/itemBt/itemBt.tscn").instance()
	chaBt.id = conf.id
	chaContainer.add_child(chaBt)
	bossWindow.popup_centered()

func doGetSpecCha(conf, specChaWindow):
	specChaWindow.hide()
	specChaWindow.queue_free()
	sys.main.player.addCha(sys.main.newChara(conf.id))
	for i in items:
		if i.id == "i_Hide_al_agreedProof":
			sys.main.player.delItem(i)

######################################定向补给箱##############################
func directBox():
	var itemWindow = utils.createWindowDialog(sys.main.get_node("ui"), "选择装备", Vector2(800, 600))
	itemWindow.popup_exclusive = true
	itemWindow.get_close_button().hide()
	var itemGrid = utils.createGridContainer(itemWindow, 7)
	itemGrid.rect_position = Vector2(20, 20)
	itemGrid.set_custom_minimum_size(Vector2(800,0))
	for i in utils.consts.itemsRare:
		var itemPanel = Panel.new()
		itemPanel.name = "panel"
		itemPanel.rect_min_size = Vector2(100, 120)
		var obj = preload("res://ui/item/item.tscn").instance()
		var items = sys.newItem(i)
		obj.init(items)
		obj.isDrag = false
		obj.rect_position = Vector2(30, 25)
		itemPanel.add_child(obj)
		utils.createItemButton(itemPanel, self, "选择", "doGetSpecItem", [i, itemWindow], Vector2(20, 80))
		itemGrid.add_child(itemPanel)
	itemWindow.popup_centered()
func doGetSpecItem(conf, itemWindow):
	itemWindow.hide()
	itemWindow.queue_free()
	sys.main.player.addItem(sys.newItem(conf))
	for i in items:
		if i.id == "i_Hide_al_directBox":
			sys.main.player.delItem(i)

######################################空白旗子##############################
func directFlag():
	var itemWindow = utils.createWindowDialog(sys.main.get_node("ui"), "选择装备", Vector2(800, 600))
	var itemGrid = utils.createGridContainer(itemWindow, 7)
	itemGrid.rect_position = Vector2(20, 20)
	itemGrid.set_custom_minimum_size(Vector2(800,0))
	for i in utils.consts.flags:
		var itemPanel = Panel.new()
		itemPanel.name = "panel"
		itemPanel.rect_min_size = Vector2(100, 120)
		var obj = preload("res://ui/item/item.tscn").instance()
		var items = sys.newItem(i)
		obj.init(items)
		obj.isDrag = false
		obj.rect_position = Vector2(30, 25)
		itemPanel.add_child(obj)
		utils.createItemButton(itemPanel, self, "选择", "doGetSpecFlag", [i, itemWindow], Vector2(20, 80))
		itemGrid.add_child(itemPanel)
	itemWindow.popup_centered()

func doGetSpecFlag(conf, itemWindow):
	itemWindow.hide()
	itemWindow.queue_free()
	sys.main.player.addItem(sys.newItem(conf))
	for i in items:
		if i.id == "i_Hide_al_directFlag":
			sys.main.player.delItem(i)

######################################补给箱##############################
func equipBox():
	var itemWindow2 = utils.createWindowDialog(sys.main.get_node("ui"), "选择装备", Vector2(700, 700))
	var itemGrid = utils.createGridContainer(itemWindow2, 6)
	itemGrid.rect_position = Vector2(20, 20)
	itemGrid.set_custom_minimum_size(Vector2(800,0))

	for i in itemData.rndPool.items:
		var itemId = i[0].id
		# if itemId == "i_azurline_u":continue
		var itemPanel = Panel.new()
		itemPanel.name = "panel"
		itemPanel.rect_min_size = Vector2(100, 120)
		var obj = preload("res://ui/item/item.tscn").instance()
		var items = sys.newItem(itemId)
		obj.init(items)
		obj.isDrag = false
		obj.rect_position = Vector2(30, 25)
		itemPanel.add_child(obj)
		utils.createItemButton(itemPanel, self, "选择", "doGetSpecItem2", [itemId, itemWindow2], Vector2(20, 80))
		itemGrid.add_child(itemPanel)
	itemWindow2.popup_centered()

func doGetSpecItem2(conf, itemWindow2):
	itemWindow2.hide()
	itemWindow2.queue_free()
	sys.main.player.addItem(sys.newItem(conf))
	for i in items:
		if i.id == "i_Hide_al_equipBox":
			sys.main.player.delItem(i)

######################################买彩票##############################
var lotteryWindow
var lotteryNum
var lotteryIndex = 0
func lotteryUI():
	if not is_instance_valid(lotteryWindow) or not lotteryWindow is WindowDialog:
		lotteryWindow = utils.createWindowDialog(sys.main.get_node("ui"), "购买彩票", Vector2(750, 350))
		var vbox = utils.createVBox(lotteryWindow)
		vbox.rect_position = Vector2(50, 50)
		vbox.name = "vbox"
		utils.createRichTextLabel(utils.consts.colorGold + "花费150金，输入0-99之间的任意整数，5回合后开奖\n开奖结果完全命中，则奖励1200PT\n开奖结果相差10点以内，奖励1200金", vbox, Vector2(650, 120))
		var le = LineEdit.new()
		le.max_length = 5
		le.name = "le"
		vbox.add_child(le)
		le.connect("text_changed", self, "inputLottery")
		utils.createItemButton(lotteryWindow, self, "确定", "doSelectLottery", [le], Vector2(210, 250))
		utils.createItemButton(lotteryWindow, self, "取消", "cancelLottery", [], Vector2(270, 250))
	sys.get_node("/root/topUi/charaInfoMsg").hide()
	lotteryWindow.popup_centered()

func doSelectLottery(le):
	if sys.main.player.gold < 150:
		sys.newBaseMsg("购买结果", "购买失败：金币不足！")
		lotteryWindow.hide()
		return
	lotteryNum = int(le.text)
	sys.main.player.plusGold(-150)
	azurCtrl.buyLottery()
	lotteryWindow.hide()

func inputLottery(text):
	if text.empty():return
	if not text.is_valid_integer() or int(text) < 0 or int(text) > 99:
		lotteryWindow.get_node("vbox").get_node("le").clear()
		sys.newBaseMsg("错误", "请输入0到99之间的整数！")

func cancelLottery():
	lotteryWindow.hide()
