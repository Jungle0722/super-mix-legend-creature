extends Chara

var utils = globalData.infoDs["g_azurlineUtils"]
var azurCtrl = globalData.infoDs["g_azurline"]
var base = globalData.infoDs["g_azurlineBase"]
var buffUtil = globalData.infoDs["g_azurlineBuffs"]
var research = globalData.infoDs["g_azurlineResearch"]
var omgCtrl = globalData.infoDs["g_azurlineOMG"]
var skillPool = globalData.infoDs["g_azurlineSkills"]
var gSiren = globalData.infoDs["g_azurlineSiren"]
var pvp = globalData.infoDs["g_azurlinePVP"]
var difficult = globalData.infoDs["g_azurlineDifficult"]
var plus = globalData.infoDs.get("g_azurlinePlus")
var illu = globalData.infoDs.get("g_azurlineIllustrate")
var relic = globalData.infoDs.get("g_azurlineRelic")

var type = ""
var type2 = ""
var tag = "azurline"
var isResearch = false
var net = azurCtrl.net
var manualDel = false
#是否能被献祭进化
var sacrifice = true
var deleting = false
#主炮口径
var gunType = "无"
#装甲类型
var armorType = "轻型"
#主炮伤害系数
var gunRate = [1, 1, 1, 0.7]

var canCopy = true
#阵营
var camp = "其他"
var campTmp = null
#是否已进行现代化改造
var upgraded = false
var pic = null
#治疗效果
var healHpL = 1
#英文名称,用于立绘检索
var ename

#角色唯一ID
var rndId:int

var level:int = 1

#额外技能槽
var exSkillSlot = []
#是否觉醒
var isAwaken:bool = false
var awakenProcess:int = 0
#阵亡次数
var deathNum = 0
#角色永久额外属性区
var attEx:Att = Att.new()
#角色锁定属性区
var attFx = utils.loadScript("AzurAtt")
#最大装备上限
var maxItem = 3
#是否使用过金刚钻
var jgzFlag = false

func _ready():
	addAtt(attEx)

func _extInit():
	._extInit()
	if team == 1 and rndId == 0 and not isSumm:
		rndId = omgCtrl.generateChaId()

func chaInfo(cha):
	var charaInfos = []
	checkRealLove()
	for i in sys.get_node("/root/topUi").get_children():
		if i.name.find("charaInfoMsg") > -1:charaInfos.append(i)
	var charaInfo = charaInfos.pop_back()
	var realLove = "否"
	if realLoveFlag:realLove = "是"
	var txt = charaInfo.get_node("txt")
	var split = txt.bbcode_text.rsplit("\n")
	var res = ""
	var cmp = cha.camp
	if cha.campTmp != null:
		cmp = cha.campTmp
	for i in range(split.size()):
		if i == 0:
			res += split[i] + "            [color=#FFA500]击杀[/color]：{0}       [color=#FFA500]阵营[/color]：{1}       [color=#FFA500]真爱[/color]：{2}\n".format({"0":cha.killNum,"1":cmp, "2":realLove})
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
			res += "  冷却：{0}%\n物理/法术吸血：{1}%/{2}%  物理/法术穿透：{3}/{4}   无视护甲/魔抗：{5}%/{6}%\n".format({"0":int(cha.att.cd*100), "1":cha.att.suck*100, "2":cha.att.mgiSuck*100, "3":cha.att.pen, "4":cha.att.mgiPen, "5":cha.att.penL*100,"6":cha.att.mgiPenL*100})
			res += "增伤：[color=#FFA500]%s%%[/color]    减伤：[color=#FFA500]%s%%[/color]    主炮口径：[color=#FFA500]%s[/color]    装甲类型：[color=#FFA500]%s[/color]\n"%[int(cha.att.atkR*100), int(cha.att.defR*100), gunType, armorType]
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
	txt.margin_top = 20
	var inManual = isInManual()
	var btnBoxR = utils.createHBox(charaInfo, Vector2(900, 600))
	var btnBoxR2 = utils.createHBox(charaInfo, Vector2(900, 550))
	var btnBoxL = utils.createHBox(charaInfo, Vector2(100, 600))
	var needSpecEvo = cha.supportSpecEvo > 0 && cha.lv < 4 and not inManual
	if needSpecEvo:
		var window = utils.createWindowDialog(charaInfo, "提示", Vector2(700, 400))
		window.popup_exclusive = true
		window.get_close_button().hide()
		utils.createItemButton(charaInfo, self, "  献祭进化！  ", "specEvoAlert", [window], Vector2(600, 600))

		var lb = utils.createRichTextLabel("点击确定，献祭当前待选人物栏最前面%d个同级角色以召唤本角色的传奇形态"%cha.supportSpecEvo, window, Vector2(500, 300))
		lb.margin_top = 50
		lb.margin_left = 50
		utils.createItemButton(window, self, "确定", "specEvo1", [window, cha, charaInfo], Vector2(200, 300))
		utils.createItemButton(window, self, "取消", "specEvo2", [window], Vector2(300, 300))

	if cha.type == "cv" || cha.getSkill("castPlane") != null:
		var window = utils.createWindowDialog(charaInfo, "提示", Vector2(600, 400))
		utils.createItemButton(btnBoxR, self, "查看机组", "viewCrew", [cha, window])
	
	utils.createItemButton(btnBoxR, self, "战斗详情", "battleDetail", [cha, charaInfo])
	utils.createItemButton(btnBoxR, self, "状态统计", "buffDetail", [cha, charaInfo])
	if not exSkillSlot.empty():
		utils.createItemButton(btnBoxR, self, "额外技能", "exSkills", [charaInfo])

	if not inManual and lv < 3 and team == 1 and not isSumm:
		utils.createItemButton(btnBoxR, self, "随机进化", "rndEvo", [cha, charaInfo])	

	if lv < 4:
		utils.createItemButton(btnBoxL, self, "查看进化树", "evoRoute", [cha, charaInfo])

	utils.createItemButton(btnBoxL, self, "切换立绘", "switchDrawing", [cha, charaInfo])	

	if chaName.find("」") > -1:
		utils.createItemButton(btnBoxL, self, "角色评论", "charaComments", [cha, charaInfo])
	if cha.team == 1:
		utils.createItemButton(btnBoxL, utils, "脱下装备", "removeAllEquip", [cha])

	if chaName.find("天鹰") > -1:
		utils.createItemButton(btnBoxR2, self, "吞噬", "eatItem", [])
	if get("isResearch") and get("level") < 11 and lv == 4 and not inManual:
		utils.createItemButton(btnBoxR2, self, "角色强化", "researchQh", [charaInfo])
	if has_method("upgrade") and get("upgraded") == false and lv == 4 and not inManual:
		utils.createItemButton(btnBoxR2, self, "角色改造", "modernization", [charaInfo])
	if sys.test:
		utils.createItemButton(btnBoxR2, self, "获得", "getCha", [cha])

	if not is_instance_valid(pic) or not pic is TextureRect:
		pic = utils.getCharaDrawing(cha)
		if pic != null:
			adjustDrawing()
			charaInfo.add_child(pic)

	if not charaInfo.get_node("Button").disabled and not needSpecEvo:
		utils.createItemButton(charaInfo, self, "  角色进化！  ", "showAlEvo", [cha, charaInfo], Vector2(700, 600))
		
	charaInfo.get_node("Button").hide()

#角色评论
var commentWindow
func charaComments(cha, charaInfo):
	if is_instance_valid(commentWindow) and commentWindow is WindowDialog:
		commentWindow.queue_free()
		commentWindow = null
	commentWindow = utils.createWindowDialog(charaInfo, "角色评论", Vector2(1400, 700))
	var context = utils.createScrollContainer(commentWindow, Vector2(1350, 600), Vector2(30, 100))
	context.name = "context"

	utils.createItemButton(commentWindow, self, "刷新", "refreshComments", [cha], Vector2(30, 30))
	utils.createItemButton(commentWindow, self, "发表", "submitComments", [cha], Vector2(100, 30))

	var lb = utils.createRichTextLabel("[color=#DC143C]每局游戏前两次评论均可获得25金，发表大量无意义评论可能被拉入黑名单", commentWindow, Vector2(900, 150))
	lb.rect_position = Vector2(30, 625)
	refreshComments(cha)
	commentWindow.popup_centered()

func refreshComments(cha):
	var body = {"chaName": getChaNameForQuery(cha)}
	var res = net.sendRequest("/azurline/comment/get", HTTPClient.METHOD_POST, to_json(body))
	if res == null:
		print("无返回数据")
		return
	res = JSON.parse(res).result
	if res == null:return
	if res.code != "success":
		print("请求失败")
		return

	var context = commentWindow.get_node("context")
	var lb
	if not context.has_node("lb"):
		lb = utils.createRichTextLabel("", context, Vector2(1200, 500))
		lb.name = "lb"
	else:
		lb = context.get_node("lb")
		lb.bbcode_text = ""
	for i in range(res.data.size()):
		var vo = res.data[i]
		lb.bbcode_text += "#{0}  [color=#008000]{1}[/color]   [color=#C0C0C0]{2}[/color] ：\n          [color=#FFD700]{3}[/color]\n".format({"0":res.data.size()-i, "1":vo.userName, "2":vo.createTime, "3":vo.content})

func submitComments(cha):
	var window = utils.createWindowDialog(commentWindow, "发表评论", Vector2(600, 400))

	var edit = TextEdit.new()
	edit.rect_position = Vector2(50, 20)
	edit.set_custom_minimum_size(Vector2(500, 300))
	window.add_child(edit)

	var b = Button.new()
	b.rect_position = Vector2(280, 330)
	b.text = "确定"
	b.connect("pressed", self, "commentSubmit", [cha, window, edit])
	window.add_child(b)

	window.popup_centered()

func getChaNameForQuery(cha):
	var name = cha.chaName.rsplit("」")[1].rsplit("·")[0]
	if name == "绫波" and cha.id != "cazurlineA":
		name += "改"
	if cha.get("type") == "siren":
		name += "·塞壬"
	if cha.get("type") == "BOSS":
		name = cha.chaName
	return name

func commentSubmit(cha, window, edit):
	var body = {"userName": utils.getPlayerName(), "chaId": cha.id, "content": edit.text, "chaName": getChaNameForQuery(cha)}
	var res = net.sendRequest("/azurline/comment/submit", HTTPClient.METHOD_POST, to_json(body))
	window.hide()
	window.queue_free()
	refreshComments(cha)
	azurCtrl.commentNum += 1
	if azurCtrl.commentNum <= 2:
		sys.main.player.plusGold(25)

	var cn = base.getSetting("commentNum", 0)
	cn += 1
	base.setSetting("commentNum", cn)

	var achiOther = base.getSetting("achiOther", [])
	if cn >= 25 and not achiOther.has("dragonKing"):
		achiOther.append("dragonKing")
		sys.newBaseMsg("通知", "成就：[color=#DC143C][龙王][/color]已达成，可在控制面板-成就系统中查看")
	if cn >= 50 and not achiOther.has("dragonGod"):
		achiOther.append("dragonGod")
		sys.newBaseMsg("通知", "成就：[color=#DC143C][龙神][/color]已达成，可在控制面板-成就系统中查看")
	base.setSetting("achiOther", achiOther)

var buffWindow
func buffDetail(cha, charaInfo):
	if is_instance_valid(buffWindow) and buffWindow is WindowDialog:
		buffWindow.queue_free()
		buffWindow = null
	buffWindow = utils.createWindowDialog(charaInfo, "状态详情", Vector2(800, 700))
	var context = utils.createScrollContainer(buffWindow, Vector2(750, 650), Vector2(30, 30))
	var taskBox = utils.createGridContainer(context, 3)

	utils.createRichTextLabel("[color=#BDB76B]状态名称", taskBox, Vector2(200, 50))
	utils.createRichTextLabel("[color=#BDB76B]状态类型", taskBox, Vector2(150, 50))
	utils.createRichTextLabel("[color=#BDB76B]剩余时间", taskBox, Vector2(150, 50))

	for i in cha.buffs:
		if i.get("buffName") == null or i.get("type") == config.EQUITYPE_EQUI:continue
		utils.createRichTextLabel("[color=#FFA500]" + i.buffName, taskBox, Vector2(200, 50))
		var type = "[color=#33ff33]增益"
		if i.isNegetive:type = "[color=#DC143C]减益"
		utils.createRichTextLabel(type, taskBox, Vector2(150, 50))
		var life = "无限"
		if i.life != null and i.life > 0:
			life = String(utils.floatScale(i.life))
		utils.createRichTextLabel(life, taskBox, Vector2(150, 50))

	var lb = utils.createRichTextLabel("[color=#C0C0C0]部分增/减益状态不显示，不代表没有(例如天赋、难度的增益效果)", buffWindow, Vector2(700, 150))
	lb.rect_position = Vector2(30, 625)
	buffWindow.popup_centered()

var evoWindow
func showAlEvo(cha, charaInfo):
	if is_instance_valid(evoWindow) and evoWindow is WindowDialog:
		evoWindow.queue_free()
		evoWindow = null
	evoWindow = utils.createWindowDialog(charaInfo, "进化", Vector2(1400, 700))

	var context = utils.createScrollContainer(evoWindow, Vector2(1350, 650), Vector2(30, 30))
	var taskBox = utils.createGridContainer(context, 8)
	for i in cha.evos:
		#本体容器
		var vbox = utils.createVBox(taskBox)

		#放入基础单位
		var hBox1 = HBoxContainer.new()
		hBox1.alignment = 1
		vbox.add_child(hBox1)
		illu.newChaBt(hBox1, i)
		hBox1.set_custom_minimum_size(Vector2(200, 100))

		var evoBtn = utils.createItemButton(vbox, self, "进化", "alEvo", [cha, charaInfo, i], Vector2(115, 155))
		var chara = sys.main.newChara(i)
		chara._extInit()
		if chara.evos.size() > 0 && chara.lv < 4:						
			#处理2级单位
			for j in chara.evos:
				# #2级单位容器
				var hBox2 = HBoxContainer.new()
				hBox2.alignment = 1
				vbox.add_child(hBox2)
				illu.newChaBt(hBox2, j)
		chara.queue_free()

	evoWindow.popup_centered()

func alEvo(cha, charaInfo, id):
	charaInfo.hide()
	utils.evoCha(cha, id, false)

func getCha(cha):
	sys.main.player.addCha(sys.main.newChara(cha.id))

func appendMeta(txt):
	for i in config.bfDir.keys():
		if txt.find(i) > -1:
			txt = txt.replace(i, "[color=#ffff55][url={key}]{key}[/url][/color]".format({"key":i}))
	return txt
		
func switchDrawing(cha, charaInfo):
	if is_instance_valid(pic) and pic is TextureRect: 
		pic.queue_free()
		pic = null
	pic = utils.switchDrawing(cha)
	if pic != null:
		adjustDrawing()
		charaInfo.add_child(pic)

func adjustDrawing():
	var width = (pic.texture.get_width() - 500)/2
	pic.rect_position = Vector2(1030-width, 20)

#机组相关
var crewExp:int = 0
var crewLv:int = 1
var crewMaxLv:int = 10
var crewEquip = "cex___planeBase"
var crewEquipName = "量产型舰载机"
var summLimit:int = 4
var summedCha = []
var summActiveLimit:int = 2
var summExpBonus:int = 1
var crewWindow = null
#查看机组
func viewCrew(cha, node):
	if is_instance_valid(crewWindow) and crewWindow is WindowDialog:
		crewWindow.queue_free()
		crewWindow = null
	crewWindow = utils.createWindowDialog(node, "机组信息", Vector2(500, 300))

	var exLv = 0
	if azurCtrl.crewTraining:
		exLv = 5

	var lb = utils.createRichTextLabel("等级：{0}/{1} (每级提高8%血量及四维)".format({"0":crewLv,"1":crewMaxLv + exLv}), crewWindow, Vector2(400, 150))
	lb.rect_position = Vector2(50, 20)
	var chaBt = preload("res://ui/itemBt/itemBt.tscn").instance()
	chaBt.id = crewEquip
	crewWindow.add_child(chaBt)
	crewWindow.popup_centered()

#起飞舰载机
func summPlane(extendAllItem = false):
	if not extendAllItem and lv == 4:extendAllItem = true
	var activeCount = 0
	for i in summedCha:
		if not i.isDeath:
			activeCount += 1
	if activeCount >= summActiveLimit:
		var sk = getSkill("castPlane")
		sk.nowTime += sk.cd/(1+att.cd) * 0.5
		return null
	if summedCha.size() >= summLimit:
		return
	var cha = summChara(crewEquip)
	if cha == null:return null
	summedCha.append(cha)
	cha.summoner = self
	cha.updateAtt()
	cha.maxItem = maxItem
	for i in items:
		var item = sys.newItem(i.id)
		if i.get("upgraded") == true && i.has_method("upgrade"):
			item.upgrade()
		cha.addItem(item)
		if not extendAllItem:break
	return cha

#召唤单位
signal summChara
func summChara(id, extendItem = false, inEnemy = false):
	var cells
	if inEnemy:
		if team == 1:
			cells = utils.cellsRight
		else:
			cells = utils.cellsLeft
		cells.shuffle()	
	else:
		cells = utils.getAllCells(team)

	var cha = null
	if inEnemy:
		for i in cells:
			if matCha(i) == null:
				cha = newChara(id, i)
				break
	if cha == null:
		cha = newChara(id, self.cell)
	if cha != null:
		cha.isSumm = true
		emit_signal("summChara", cha)
		if extendItem:
			cha.maxItem = maxItem
			for i in items:
				var it = sys.newItem(i.id)
				if it.has_method("toJson"):
					it.fromJson(i.toJson())
				cha.addItem(it)
		difficult.summDiffBonus(cha)
	return cha

#召唤单位 - 作为敌人出场
func summEnemy(id, extendItem = false):
	var cha = sys.main.newChara(id, 3 - team)
	sys.main.map.add_child(cha)
	var cells = utils.getAllCells(2)
	for i in cells:
		if matCha(i) == null:
			# cha.setCell(i)
			sys.main.setMatCha(i, cha)
			cha.position = sys.main.map.map_to_world(i)
			break
	if extendItem:
		for i in items:
			var item = sys.newItem(i.id)
			if item.has_method("toJson"):
				item.fromJson(i.toJson())
			cha.addItem(item)
	return cha

#覆写原版函数
func newChara(id, cell):
	var cells = utils.getAllCells(team)
	cells.shuffle()	
	var vs = [Vector2(0, 0), Vector2(1, 0), Vector2( - 1, 0), Vector2(0, 1), Vector2(0, - 1), Vector2(1, 1), Vector2( - 1, 1), Vector2( - 1, - 1), Vector2(1, - 1)]
	var cl = null
	for i in vs:
		var lc = i + cell
		if matCha(lc) == null:
			cl = lc
			break
	if cl == null or not sys.main.isMatin(cl) or matCha(cl) != null:
		#召唤失败，尝试在其他位置重新召唤
		for i in cells:
			if matCha(i) == null:
				cl = i
				break
	if cl != null and sys.main.isMatin(cl) and matCha(cl) == null:
		var cha = sys.main.newChara(id, team)
		sys.main.map.add_child(cha)
		sys.main.setMatCha(cl, cha)
		cha.position = sys.main.map.map_to_world(cl)
		cha.isSumm = true
		cha.newEff("sk_zhao")
		emit_signal("onNewChara", cha)
		sys.main.emit_signal("onCharaNewChara", cha)
		return cha
	
func _onBattleEnd():
	._onBattleEnd()
	summedCha = []

#献祭进化
func specEvoAlert(window):
	window.popup_centered()

func specEvo1(window, cha, charaInfo):
	window.hide()
	charaInfo.hide()
	if cha.evos.empty():
		sys.newBaseMsg("提示", "该角色不能进化")
		return
	var chas = utils.getReadyChas()
	var waitDel = []
	for i in chas:
		if waitDel.size() >= cha.supportSpecEvo:break
		if i.lv == cha.lv && i != self and i.get("sacrifice") != false:
			waitDel.append(i)
	if waitDel.size() == cha.supportSpecEvo:
		# waitDel.append(cha)
		var afterEvoCha = sys.main.newChara(cha.evos[0])
		# sys.main.player.addCha(afterEvoCha)
		utils.extendsEvo(afterEvoCha, cha)
		var index = cha.supportSpecEvo
		while index > 0:
			var wc = waitDel[index-1]
			utils.removeAllEquip(wc)
			if wc.get("manualDel") == false:
				wc.manualDel = true
			wc.deleteSelf()
			index -= 1
		omgCtrl.onEvo(afterEvoCha)
	else:
		if not cha.evos.empty():
			sys.newBaseMsg("提示", "可献祭素材不足")
			return
		
func specEvo2(window):
	window.hide()

func deleteSelf():
	deleting = true
	var node = self.get_parent()
	sys.main.delMatChara(self)
	if node != null and self.isItem:
		node.queue_free()

#====================================随机进化===============================
func rndEvo(cha, window):
	var cost = cha.lv * 35
	if sys.main.player.gold < cost:
		sys.newBaseMsg("提示", "金币不足，需要：%d"%cost)
		return

	window.hide()
	var chas = utils.getReadyChas()
	var waitDel = []
	for i in chas:
		if waitDel.size() >= 2:break
		if i.lv == cha.lv && i != self and i.get("sacrifice") != false:
			waitDel.append(i)

	if waitDel.size() == 2:
		waitDel.append(cha)
		var index = 2
		while index >= 0:
			var node = waitDel[index].get_parent()
			utils.removeAllEquip(waitDel[index])
			if waitDel[index].get("manualDel") == false:
				waitDel[index].manualDel = true
			if waitDel[index].isItem:
				node.queue_free()
			else:
				waitDel[index].remove()
			index -= 1
		var afterEvoCha = sys.main.newChara(doRndEvo())
		sys.main.player.addCha(afterEvoCha)
		sys.main.player.plusGold(-cost)
		omgCtrl.onEvo(afterEvoCha)
		utils.afterEvoCheck(cha.id)
	else:
		sys.newBaseMsg("提示", "可献祭素材不足")
		return

func doEvo4():
	return sys.rndListItem(utils.exLv4)

func doEvo3():
	return sys.rndListItem(utils.exLv3)

func doEvo2():
	return sys.rndListItem(utils.lv2)

func doRndEvo():
	#越级进化概率
	if self.lv == 3:
		return doEvo(4)
	else:
		return doEvo(self.lv + 1)

func doEvo(lv):
	match lv:
		2:return doEvo2()
		3:return doEvo3()
		4:return doEvo4()
#===================================================================
func _onHurt(atkInfo):
	._onHurt(atkInfo)
	#血量保护
	if team == 1 and lv > 2 and difficult.hpProtect > 0:
		atkInfo.hurtVal = min(att.maxHp*difficult.hpProtect, atkInfo.hurtVal)

#新建技能统一封装
func addSkill(text, name, id = null, cd = null, index = -1):
	if id != null and cd != null:
		addCdSkill(id, cd)
	text = text.replace("{damage}", "[color=#DC143C]{damage}[/color]")
	text = text.replace("{cd}", "[color=#DC143C]{cd}[/color]")
	var skillText = "[color=#FFA500][{name}][/color]-{color}{text}[/color]{tmpName}".format({"name":name,"text":text, "color":skillColors[3]})
	skillText += name
	if index == -1:
		addSkillTxt(skillText)
	else:
		skillStrs[index] = skillText

	if skillData.has(name):
		skillData.get(name).text = skillText
	else:
		skillData[name] = {"text":skillText, "name":name, "id":id, "cd":cd}


var skillColors = ["[color=#4080C6]", "[color=#7A70FE]", "[color=#BA7AFF]", "[color=#25BCAF]"]
var skillData = {}
#计算技能效果
func getSkillEffect(name):
	return null

class AttackInfo:
	extends AtkInfo
	#伤害名称
	var skill
	#伤害倍率
	var factor = 1
	func _init():
		._init()
		pass

func azurHurtChara(cha, dmg, hurtType, atkType, from = null, canCri = false):
	if cha == null or cha.isDeath:return
	pause(0.15, false)
	hitHua = true
	var atkInfo = AttackInfo.new()
	atkInfo.skill = from
	atkInfo.rate = 1
	atkInfo.hitCha = cha
	atkInfo.atkCha = self
	atkInfo.hitObj = cha
	atkInfo.atkObj = self
	atkInfo.hurtType = hurtType
	atkInfo.hurtVal = dmg
	atkInfo.atkType = atkType
	atkInfo.atkVal = dmg
	if canCri && sys.rndPer(att.cri*100):
		atkInfo.isCri = true
		atkInfo.hurtVal *= 2 + (2 * att.criR)
		atkInfo.atkVal *= 2 + (2 * att.criR)
	else: 
		atkInfo.isCri = false

	if atkType == Chara.AtkType.NORMAL:
		atkInfo.isAtk = true
	else:
		atkInfo.isAtk = false
	atkInfo.isMiss = false
	cha.hurtArit(atkInfo)

var damageData = {}
var skillNum = {}
var dpsData = {}
var hurtData = {}
func damageCallback(atkInfo):
	if atkInfo.atkType == Chara.AtkType.NORMAL and atkInfo.get("skill") == null:
		doDamageCallback(atkInfo.hurtVal, "普攻", atkInfo.hitCha)
	elif atkInfo.get("skill") != null:
		doDamageCallback(atkInfo.hurtVal, atkInfo.get("skill"), atkInfo.hitCha)
	else:
		doDamageCallback(atkInfo.hurtVal, "其它", atkInfo.hitCha)

func doDamageCallback(dmg, name, hitCha):
	utils.dicPlus(damageData, name, dmg)
	utils.dicPlus(skillNum, name, 1)
	if hitCha == null or not is_instance_valid(hitCha):return
	if hitCha.get("tag") != "azurline":return
	utils.dicPlus(dpsData, hitCha, dmg)
	utils.dicPlus(hitCha.hurtData, self, dmg)

#来自召唤物的伤害回调
func damageCallback2(atkInfo):
	doDamageCallback(atkInfo.hurtVal, "召唤物", atkInfo.hitCha)

var battleWindow
func battleDetail(cha, charaInfo):
	if is_instance_valid(battleWindow) and battleWindow is WindowDialog:
		battleWindow.queue_free()
		battleWindow = null
	battleWindow = utils.createWindowDialog(charaInfo, "上回合战斗详情", Vector2(450, 550))

	var hbox = utils.createHBox(battleWindow)
	hbox.rect_position = Vector2(20, 20)

	utils.createItemButton(hbox, self, "伤害详情", "dmgDetail")
	utils.createItemButton(hbox, self, "承伤详情", "hurtDetail")

	var statisScroll = utils.createScrollContainer(battleWindow, Vector2(400, 400), Vector2(20, 100))
	var vbox = utils.createVBox(statisScroll)
	vbox.rect_position = Vector2(20, 20)
	vbox.name = "vbox"
	for i in damageData.keys():
		utils.createRichTextLabel("[color=#DC143C]{name}[/color]：伤害{text}， 次数{num}".format({"name":i, "text":int(damageData.get(i)), "num":skillNum.get(i)}), vbox, Vector2(400, 50))
	
	battleWindow.popup_centered()

func dmgDetail():
	var txt = ""
	for i in dpsData.keys():
		var name = i.chaName
		if i.isSumm:name += "(召唤物)"
		txt += "[color=#DC143C]{name}[/color]：     {dmg}\n".format({"name":name, "dmg":int(dpsData.get(i))})
	utils.openHelpWindow(txt)

func hurtDetail():
	var txt = ""
	for i in hurtData.keys():
		var name = i.chaName
		if i.isSumm:name += "(召唤物)"
		txt += "[color=#DC143C]{name}[/color]：     {dmg}\n".format({"name":name, "dmg":int(hurtData.get(i))})
	utils.openHelpWindow(txt)

var evoRouteWindow
func evoRoute(cha, charaInfo):
	if is_instance_valid(evoRouteWindow) and evoRouteWindow is WindowDialog:
		evoRouteWindow.queue_free()
		evoRouteWindow = null
	evoRouteWindow = utils.createWindowDialog(charaInfo, "进化路线", Vector2(1300, 800))
	illu.createTab(evoRouteWindow, cha.chaName, [cha.id])
	evoRouteWindow.popup_centered()
#显示额外技能
var exSkillWindow
func exSkills(node):
	if is_instance_valid(exSkillWindow) and exSkillWindow is WindowDialog:
		exSkillWindow.queue_free()
		exSkillWindow = null
	exSkillWindow = utils.createWindowDialog(node, "额外技能", Vector2(1200, 450))

	var context = VBoxContainer.new()
	context.margin_top = 50
	context.margin_left = 50
	exSkillWindow.add_child(context)

	for i in exSkillSlot:
		utils.createRichTextLabel("{0}[{1}]:{3}".format({"0":"[color=#BDB76B]", "1":i.sname,"3":i.text}), context, Vector2(1000, 50))
	
	exSkillWindow.popup_centered()

#是否在图鉴中
func isInManual():
	var father = self.get_parent()
	if father != null:
		return team != 2 && father.get("id") == self.id
	return false

#科研强化
func researchQh(charaInfo):
	var window = utils.createWindowDialog(charaInfo, "提示", Vector2(700, 400))
	window.popup_exclusive = true
	window.get_close_button().hide()
	var lb = utils.createRichTextLabel("点击确定，花费120PT，对当前角色进行强化\n当前强化等级：%d/10"%[level-1], window, Vector2(500, 300))
	lb.margin_top = 50
	lb.margin_left = 50
	utils.createItemButton(window, self, "确定", "researchQh1", [window], Vector2(200, 300))
	utils.createItemButton(window, self, "取消", "researchQh2", [window], Vector2(300, 300))
	window.popup_centered()

#确认强化
func researchQh1(window):
	window.hide()
	window.queue_free()
	if azurCtrl.pt < 150:
		sys.newBaseMsg("提示", "PT点数不足，需要150点！")
		return
	if level > 10:
		sys.newBaseMsg("提示", "当前角色已经强化至满级")
		return
	azurCtrl.pt -= 150
	call("strengthen")

#取消强化
func researchQh2(window):
	window.hide()
	window.queue_free()

#现代化改造
func modernization(charaInfo):
	var window = utils.createWindowDialog(charaInfo, "提示", Vector2(700, 400))
	window.popup_exclusive = true
	window.get_close_button().hide()
	var price = 600
	if realLoveFlag:
		price -= 100
	var lb = utils.createRichTextLabel("点击确定，花费%d金币，对当前角色进行现代化改造"%price, window, Vector2(500, 300))
	lb.margin_top = 50
	lb.margin_left = 50
	utils.createItemButton(window, self, "确定", "modernization1", [window, price, charaInfo], Vector2(200, 300))
	utils.createItemButton(window, self, "取消", "modernization2", [window], Vector2(300, 300))
	window.popup_centered()

#确认改造
func modernization1(window, price, charaInfo):
	window.hide()
	window.queue_free()
	charaInfo.hide()
	if sys.main.player.gold < price:
		sys.newBaseMsg("提示", "金币不足！")
		return
	sys.main.player.plusGold(-price)
	call("upgrade")
	upgraded = true

#取消改造
func modernization2(window):
	window.hide()
	window.queue_free()

#真爱成就
var realLoveFlag
func checkRealLove():
	if realLoveFlag != null:return realLoveFlag
	var achiChara = base.getSetting("achiChara", {})
	for i in achiChara.values():
		if chaName.find(i) > -1:
			realLoveFlag = true
			break
	if realLoveFlag == null:realLoveFlag = false
#设置阵营
var realCamp = null
func setCamp(camp):
	if not azurCtrl.campMaster.empty() and (isResearch || id.find("alhide") > -1):
		camp = azurCtrl.campMaster[0]
	self.camp = camp
	if realCamp != null:
		self.camp = realCamp

func hurtArit(atkInfo):
	if atkInfo.atkCha.get("tag") != "azurline":
		.hurtArit(atkInfo)
		return
	if isDeath or isItem:return 
	if hurtNum > 10:return
	#塞壬觉醒检测
	if gSiren.sirenAwaken and difficult.step > 95 and team == 2 and atkInfo.atkCha.type != "siren" and not atkInfo.atkCha.isSumm:
		return
	checkDeath(atkInfo)
	if atkInfo.get("factor") == null:
		var attack = AttackInfo.new()
		var skip_variables = ["Script Variables", "script"]
		for i in atkInfo.get_property_list():
			var key = i.name
			if not key in skip_variables and key != "":
				attack.set(key, atkInfo.get(key))
		atkInfo = attack
	emit_signal("onAtkInfo", atkInfo)
	_onAtkInfo(atkInfo)
	hurtNum += 1
	if not atkInfo.atkCha.isItem:
		atkInfo.atkCha.emit_signal("onAtkInfo", atkInfo)
		atkInfo.atkCha._onAtkInfo(atkInfo)
	if atkInfo.hurtType == HurtType.PHY:
		var defVal = clamp(att.def - att.def * atkInfo.atkCha.att.penL - atkInfo.atkCha.att.pen, 0, 10000)
		atkInfo.hurtVal = atkInfo.atkVal * (100 / (100 + defVal))
	elif atkInfo.hurtType == HurtType.MGI:
		var defVal = clamp(att.mgiDef - att.mgiDef * atkInfo.atkCha.att.mgiPenL - atkInfo.atkCha.att.mgiPen, 0, 10000)
		atkInfo.hurtVal = atkInfo.atkVal * (100 / (100 + defVal))
	else :
		atkInfo.hurtVal = atkInfo.atkVal
	if atkInfo.canCri and randf() < atkInfo.atkCha.att.cri:
		atkInfo.hurtVal *= 2 * (1 + atkInfo.atkCha.att.criR)
		atkInfo.isCri = true
	if atkInfo.atkType == AtkType.NORMAL and randf() < att.dod:
		atkInfo.isMiss = true
	
	atkInfo.hurtVal *= 1 + atkInfo.atkCha.att.atkR - att.defR
	#去掉负伤害
	if atkInfo.hurtVal <= 0:return
	if not isItem:
		atkInfo.atkCha.emit_signal("onAtkChara", atkInfo)
		atkInfo.atkCha._onAtkChara(atkInfo)

	if atkInfo.get("factor") != null:
		atkInfo.hurtVal	*= atkInfo.factor

	if not isItem:
		emit_signal("onHurt", atkInfo)
		_onHurt(atkInfo)
	if not atkInfo.isMiss:
		#处理护盾
		if shield > 0:
			var shieldDmg = min(shield, atkInfo.hurtVal)
			changeShield(-shieldDmg)
			if shield <= 0:
				att.hp -= (atkInfo.hurtVal - shieldDmg)
		else:
			att.hp -= atkInfo.hurtVal
		# sys.main.emit_signal("onCharaHurt", atkInfo)
	if not isItem:
		#处理溢出伤害
		if att.hp < 0:
			atkInfo.hurtVal += att.hp
		emit_signal("onHurtEnd", atkInfo)
	atkInfo.canCri = false
	if atkInfo.atkType == AtkType.NORMAL and atkInfo.atkCha.isSumm and atkInfo.atkCha.att.atkRan == 1:
		self.aiCha = atkInfo.atkCha
	#处理吸血
	if atkInfo.atkCha.att.reHp > -0.9 and not atkInfo.isMiss and atkInfo.atkCha.get("type") != "BOSS":
		if atkInfo.atkCha.att.suck > 0 and atkInfo.hurtType == HurtType.PHY:
			atkInfo.atkCha.healCha(atkInfo.atkCha, atkInfo.hurtVal * atkInfo.atkCha.att.suck, 0.1)
		elif atkInfo.atkCha.att.mgiSuck > 0 and atkInfo.hurtType == HurtType.MGI:
			atkInfo.atkCha.healCha(atkInfo.atkCha, atkInfo.hurtVal * atkInfo.atkCha.att.mgiSuck, 0.1)
	
	if sys.main.isNumVis:
		var node = sys.newEff("numHit", position + sprcPos, false, 1)
		node.z_index = 51;
		node.init(atkInfo.hurtVal, self)
		if atkInfo.isMiss:node.play("miss")
		elif atkInfo.hurtType == HurtType.PHY:node.play("wu")
		elif atkInfo.hurtType == HurtType.MGI:node.play("mo")
		elif atkInfo.hurtType == HurtType.REAL:node.play("zhen")
		if atkInfo.isCri:
			node.lab.text += "!"
	checkDeath(atkInfo)

func checkDeath(atkInfo):
	if att.hp <= 0.0 and isDeath == false:
		att.hp = 0
		isDeath = true
		if not isItem:
			emit_signal("onDeath", atkInfo)
			_onDeath(atkInfo)
			atkInfo.atkCha.emit_signal("onKillChara", atkInfo)
			atkInfo.atkCha._onKillChara(atkInfo)
			sys.main.emit_signal("onCharaDel", self)
		sys.delEff(position, dire)
		del()

var forceHurtFlag = false
func plusHp(val, veff = true):
	if isDeath:return 
	if not forceHurtFlag and val < 0:
		 return
	val = val * (1 + att.reHp)
	att.hp += val
	if att.hp > att.maxHp:att.hp = att.maxHp
	emit_signal("onPlusHp", val)
	if veff and val != 0 and difficult.step < 100:
		var eff = newEffIn("plusHp")
		eff.setNorPos(sprcPos)
		eff.setAmount(int(val / att.maxHp * 40))
		if sys.main.isNumVis:
			var node = null
			if isItem:node = newEffIn("numHit")
			else :node = newEff("numHit")
			node.setNorPos(sprcPos)
			node.scale = Vector2(1, 1)
			node.init(val, self)
			node.play("hp")		

#变更护盾值
var shield:int = 0
var shieldLimit = null
func changeShield(num):
	if num > 0:
		num *= (att.reHp + 1)
		num *= (relic.shieldBonus + azurCtrl.shieldBonus)
	shield += num
	if shieldLimit == null and shield > att.maxHp:
		shield = att.maxHp
	elif shieldLimit != null and shield > shieldLimit:
		shield = shieldLimit
	shield = max(0, int(shield))

	tpView.set_value(shield)
	if shieldLimit == null:
		tpView.set_max(att.maxHp)
	else:
		tpView.set_max(shieldLimit)

func plusShield(num):
	if num < 0 and team == 1:
		num *= -1
	changeShield(num)			

#护盾条相关
var tpView
#护盾条初始化
func tpViewInit():
	if isSumm:return
	tpView = TextureProgress.new()
	var imt = utils.createImageTexture("cex___warship/mp.png")
	tpView.set_progress_texture(imt)
	tpView.set_fill_mode(4)
	tpView.set_max(att.maxHp)
	tpView.set_step(0.01)
	tpView.set_min(0)
	tpView.set_value(0)
	tpView.set_position(Vector2(-63, -25))
	self.get_node("ui").add_child(tpView)

signal healCha
#治疗并统计
func healCha(cha, num, rate = 1):
	if team == 1:
		num *= (healHpL + azurCtrl.healHpL)
	else:
		num = min(cha.att.maxHp * 0.1, num)
	var shieldNum = 0
	if cha.has_method("changeShield"):
		if cha.att.hp >= cha.att.maxHp:
			shieldNum = num
		elif cha.att.hp + num >= cha.att.maxHp:
			shieldNum = num - (cha.att.maxHp - cha.att.hp)
		cha.changeShield(shieldNum * rate)	
	if cha.team == 2 or num > 0:
		num = min(cha.att.maxHp - cha.att.hp, num)
		cha.plusHp(num)
	if num + shieldNum > 0 and not isSumm:
		call("increDealNum", num + shieldNum)
		emit_signal("healCha", cha)

func infoUp():
	evos.clear()
	skillStrs.clear()
	skills.clear()
	attAdd.clear()
	_info()
	_extInit()
	if isItem == false:
		pass
	if id != "":
		if chaData.infoDs[id].dir.left(8) != "res://ex":
			var im = Image.new()
			im.load("%s/%s/cha.png" % [chaData.infoDs[id].dir, id])
			var imt = ImageTexture.new()
			imt.create_from_image(im)
			imt.flags = 4
			img.texture = imt
		else :img.texture = load("res://ex/chara/%s/cha.png" % id)
		img.margin_top = - img.texture.get_height() + 35
		img.margin_left = - img.texture.get_width() / 2
		$ui / chaName.text = chaName
		$ui / chaName.modulate = Color(config.itemGradeColors[lv - 1])
		sprcPos = Vector2(0, - img.texture.get_height() / 2)
		if not isItem:
			$ui / chaName.hide()
		else :
			$ui / chaName.show()
	var lvL = 1 + (lv - 1) * 1
	img.rect_pivot_offset = Vector2(img.texture.get_width() * 0.5, img.texture.get_height())
	attInfo.atkRan = attCoe.atkRan
	attInfo.maxHp = attCoe.maxHp * 112.5 * lvL
	attInfo.atk = attCoe.atk * 6 * lvL
	attInfo.mgiAtk = attCoe.mgiAtk * 10 * lvL
	attInfo.def = attCoe.def * 10 * lvL
	attInfo.mgiDef = attCoe.mgiDef * 10 * lvL
	attInfo.cri = 0.2
	upAtt()		

func _on_Sprite_pressed():
	var s = getInfo()
	var msg = sys.newMsg("charaInfoMsg")
	msg.init(self, s)
	emit_signal("onPressed", self)
	chaInfo(self)

func addItem(item):
	if item != null and item.type == config.EQUITYPE_EQUI and (items.size() < maxItem + azurCtrl.globalItemSlot or utils.isExtraItem(item)):
		addBuff(item)
		items.append(item)
		emit_signal("onAddItem", item)
		return true
	return false
func upAtt(all = true):
	var hpL = 1
	if att.maxHp > 0:
		hpL = att.hp / att.maxHp
	att.clear()
	att.spd = 1.0
	for i in atts:
		att.plus(i)
	for i in config.attRdsKeys:
		att.info[config.attRds[i]] *= 1 + att.info[i]
	#属性最小值判定
	for i in att.info.keys():
		var at = att.get(i)
		var minAt = attFx.minLimit.get(i)
		if at < minAt:
			att.set(i, minAt)

	att.hp = att.maxHp * hpL
	isUpAtt = false
	for i in attFx.info.keys():
		var at = attFx.get(i)
		if at >= 0:
			att.set(i, at)

func castBuff(cha, buff):
	buff.casCha = self
	return cha.addBuff(buff)

func hurtChara(cha, val, hurtType = HurtType.PHY, atkType = AtkType.SKILL):
	var af = AttackInfo.new()
	af.atkVal = val
	af.atkType = atkType
	af.hurtType = hurtType
	af.atkCha = self
	af.hitCha = cha
	cha._hit(af)