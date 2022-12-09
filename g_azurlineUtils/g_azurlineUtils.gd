extends Node
#心智魔方回收天赋当前十连进度
var mindCubeNum = 0
var consts
var buffs
var path
var base
var drawing
var azurCtrl
var plus
var file = File.new()
var difficult
var research
var osName
var pc
var omgCtrl
var relic
func _ready():
	pass
func _init():
	call_deferred("azurlineUtilsInit")
	pass
func _connect():
	pass

var lv1 = []
var lv2 = []
var lv3 = []
var lv4 = []
var exLv3 = []
var exLv4 = []
#按照舰种+等级存储的角色ID字典
var shipTypeDic = {}

#特殊角色池
var specChas = [
]
var specChasAll = [
	{"id":"cex___al-nagato", "name":"长门"},
	{"id":"cex___al-hood", "name":"胡德"},
	{"id":"cex___als-shinano", "name":"信浓"},
	{"id":"cex___als-chapayev", "name":"恰巴耶夫"},
	{"id":"cex___als-kii", "name":"纪伊"},
	{"id":"cex___als-kashino", "name":"樫野"},
	{"id":"cex___als-northCarolina", "name":"北卡罗来纳"},
	{"id":"cex___als-mikasa", "name":"三笠"},
	{"id":"cex___als-laffey", "name":"拉菲"},
	{"id":"cex___als-roon", "name":"罗恩"},
	{"id":"cex___als-zuikaku", "name":"瑞鹤"},
	{"id":"cex___als-avrora", "name":"阿芙乐尔"},
	{"id":"cex___als-sovetskaya", "name":"苏维埃罗西亚"},
	{"id":"cex___als-kaga", "name":"加贺"},
	{"id":"cex___als-tirpitz", "name":"提尔比茨"},
	{"id":"cex___als-u37", "name":"U37"},
	{"id":"cex___als-washington", "name":"华盛顿"},
	{"id":"cex___als-javelin", "name":"标枪"},
	{"id":"cex___als-veneto", "name":"维托里奥·维内托"},
	{"id":"cex___als-aquila", "name":"天鹰"},
	{"id":"cex___als-ryuho", "name":"龙凤"},
	{"id":"cex___als-dyork", "name":"约克公爵"},
	{"id":"cex___als-amagi", "name":"天城"},
	{"id":"cex___als-newJersey", "name":"新泽西"},
	{"id":"cex___als-z23", "name":"Z23"},
	{"id":"cex___als-shengHei", "name":"圣黑之星"},
	{"id":"cex___als-h39", "name":"腓特烈大帝"},
	{"id":"cex___als-champagne", "name":"香槟"},
	{"id":"cex___als-daofeng", "name":"岛风"},
	{"id":"cex___als-huteng", "name":"胡滕"},
]

var deathWordChas = ["cazurlineB_5_1", "cazurlineB_5_1_1", "cazurlineC_3", "cazurlineC_3_1", "cazurlineC_3_1_1", "cazurlineC_3_2", "cazurlineC_3_2_1",
"cazurlineC_5", "cazurlineC_5_1", "cazurlineC_5_1_1", "cazurlineC_5_2", "cazurlineC_5_2_1", "cazurlineD_3_2_1", "cazurlineB_5_2", "cazurlineB_5_2_1"]

var rarePlanes = ["cex___plane-XSB3C", "cex___plane-FlyDragon", "cex___plane-Bumblebee"]

func azurlineUtilsInit():
	buffs = globalData.infoDs["g_azurlineBuffs"]
	consts = load("%s/azurline_ctrl/Constants.gd" % [chaData.infoDs["cazurlineA"].dir]).new()
	path = chaData.infoDs["cazurlineA"].dir
	base = globalData.infoDs["g_azurlineBase"]
	drawing = globalData.infoDs["g_azurlineDrawing"]
	azurCtrl = globalData.infoDs["g_azurline"]
	difficult = globalData.infoDs["g_azurlineDifficult"]
	research = globalData.infoDs["g_azurlineResearch"]
	omgCtrl = globalData.infoDs["g_azurlineOMG"]
	relic = globalData.infoDs["g_azurlineRelic"]
	if globalData.infoDs.has("g_azurlinePlus"):
		plus = globalData.infoDs["g_azurlinePlus"]
	osName = OS.get_name()
	if osName != "Android":
		pc = load("%s/azurline_ctrl/PC.gd" % [chaData.infoDs["cazurlineA"].dir]).new()
	
#获得随机装备ID
func getRandomItem(type = "DEFAULT"):
	return sys.rndListItem(consts.itemAll)

#获得随机技能书，若未指定稀有度，则按照当前玩家等级动态获得稀有度
func getRandomSkillBook(r = null):
	if r == null:
		r = getRandomRarity()
	var item = sys.newItem("i_Hide_al_skill%d"%r)
	item.repair(r)
	sys.main.player.addItem(item)
func getSkillBook(sid, r):
	if r == null:
		r = getRandomRarity()
	var item = sys.newItem("i_Hide_al_skill%d"%r)
	item.repair(r, sid)
	sys.main.player.addItem(item)

#动态决定稀有度
var r3=[0, 0, 2, 3,  4,  5,  6,  7,  8, 10]
# var r4=[0, 0, 0, 0,  1,  2,  3,  4,  5,  6]
func getRandomRarity(buff = 0):
	if sys.main == null:return 1
	var j = sys.main.player.lv
	if j > 10:
		j = 10
	j -= 1
	var n = sys.rndRan(0, 101)
	if n < r3[j] + buff:
		return 3
	else:
		return 2
#角色是否在场上
func inBattle(cha):
	return cha.get_parent() is TileMap
#装备升级
func itemUpgrade(item):
	var masCha = item.masCha
	if masCha.isSumm || item.get("upgraded") == null || item.upgraded:return
	yield(sys.get_tree().create_timer(0.2), "timeout")
	var n = 0
	for i in masCha.items:
		if  i.id == item.id && not i.upgraded:
			n += 1
	if n == 3:
		item.upgraded = true
		item.upgrade()
		var js = item.toJson()
		var newItem = sys.newItem(js.id)
		sys.main.player.addItem(newItem)
		newItem.fromJson(js)
		var index = masCha.items.size()-1
		while(index>=0):
			var i = masCha.items[index]
			sys.main.player.delItem(i)
			index -= 1
		masCha.addItem(newItem)
		newItem.afterFromJson(js)

func addShotCutToBtn(btn, keys):
	var sc = ShortCut.new()
	var key = InputEventKey.new() 
	key.scancode = keys
	sc.set_shortcut(key)
	btn.shortcut = sc
	btn.shortcut_in_tooltip = true

#根据参数创建按钮
func createItemButton(baseNode, bindInstance, text, callback, args=[], position = Vector2(90, 170), shortCut = null, bindSelf = false):
	var b = Button.new()
	b.rect_position = position
	b.text = text
	if bindSelf:
		args.append(b)
	b.connect("pressed", bindInstance, callback, args)
	baseNode.add_child(b)
	if shortCut != null:
		addShotCutToBtn(b, shortCut)
	return b

func createTextureButton(baseNode, bindInstance, img, disabledImg, callback, args=[], position = Vector2(90, 170)):
	var b = TextureButton.new()
	b.rect_position = position
	b.set_normal_texture(createImageTexture(img))
	b.set_disabled_texture(createImageTexture(disabledImg))
	b.connect("pressed", bindInstance, callback, args)
	baseNode.add_child(b)
	return b

func createLabel(text, baseNode):
	var lb = Label.new()
	lb.text = text
	baseNode.add_child(lb)
	return lb

func createRichTextLabel(text, baseNode, size = Vector2(580, 50), position = null):
	var lb = RichTextLabel.new()
	lb.bbcode_text = text
	lb.bbcode_enabled = true
	lb.push_align(0)
	lb.set_custom_minimum_size(size)
	lb.name = "RichTextLabel"
	baseNode.add_child(lb)
	if position != null:
		lb.rect_position = position
	return lb
#左半场
const cellsLeft = [
	Vector2(0,0), Vector2(1,0), Vector2(2,0), Vector2(3,0), Vector2(4,0),

	Vector2(0,1), Vector2(1,1), Vector2(2,1), Vector2(3,1), Vector2(4,1),

	Vector2(0,2), Vector2(1,2), Vector2(2,2), Vector2(3,2), Vector2(4,2),

	Vector2(0,3), Vector2(1,3), Vector2(2,3), Vector2(3,3), Vector2(4,3),

	Vector2(0,4), Vector2(1,4), Vector2(2,4), Vector2(3,4), Vector2(4,4),

	Vector2(0,5), Vector2(1,5), Vector2(2,5), Vector2(3,5), Vector2(4,5)
]
#右半场单元格
const cellsRight = [
	Vector2(5,0), Vector2(6,0), Vector2(7,0), Vector2(8,0), Vector2(9,0),

	Vector2(5,1), Vector2(6,1), Vector2(7,1), Vector2(8,1), Vector2(9,1),

	Vector2(5,2), Vector2(6,2), Vector2(7,2), Vector2(8,2), Vector2(9,2),

	Vector2(5,3), Vector2(6,3), Vector2(7,3), Vector2(8,3), Vector2(9,3),

	Vector2(5,4), Vector2(6,4), Vector2(7,4), Vector2(8,4), Vector2(9,4),

	Vector2(5,5), Vector2(6,5), Vector2(7,5), Vector2(8,5), Vector2(9,5)
]

func getAllCells(team):
	if team == 1:
		return cellsLeft + cellsRight
	elif team == 2:
		return cellsRight + cellsLeft

func getAllyCells(team):
	if team == 1:
		return cellsLeft
	elif team == 2:
		return cellsRight

func getRndCell(team):
	if team == 1:
		return sys.rndListItem(cellsLeft)
	elif team == 2:
		return sys.rndListItem(cellsRight)
	else:
		return sys.rndListItem(cellsLeft + cellsRight)

func getReadyChas():
	var chas = []
	#获取备战席的角色
	for i in sys.main.btGrid.get_children():
		if i.get_children().size() == 0:continue
		var cha:Chara = i.get_child(0)
		chas.append(cha)
	return chas

func rollItem(itm, cha, title = "扭蛋结果", bonus = 0):
	var xx = sys.newMsg("jiangLiMsg")
	xx.get_node("Panel/Label").text = title
	xx.get_node("Panel/Button2").hide()
	var gachaGrid = GridContainer.new()
	gachaGrid.set_columns(5)
	gachaGrid.rect_position = Vector2(150, 75)
	xx.get_node("Panel").add_child(gachaGrid)
	if itm >=1:
		for i in range(itm):
			var item1
			if sys.rndPer(85):
				item1 = sys.newItem(itemData.rndPool.rndItem().id)
			else:
				item1 = sys.newItem(getRandomItem("RARE"))
			sys.main.player.addItem(item1)
			var itemBt = load("res://ui/item/item.tscn").instance()
			itemBt.init(item1)
			var vbox = VBoxContainer.new()
			vbox.rect_min_size = Vector2(120, 120)
			vbox.alignment = 1#对齐方式，0是开头对齐，1是中心对齐，2是末端对齐
			vbox.add_child(itemBt)
			gachaGrid.add_child(vbox)
	if cha >=1:
		hadUp = false
		for i in range(cha):
			# yield(sys.get_tree().create_timer(0.05), "timeout")
			var cha1 = getRndCha(5 + relic.charaBuildBonus + bonus)
			cha1.get_node("ui/hpBar").visible = false

			var chaBt=preload("res://ui/itemBt/itemBt.tscn").instance()
			chaBt.id=cha1.id
			sys.main.player.addCha(sys.main.newChara(cha1.id))
			gachaGrid.add_child(chaBt)
	if not title == "军备补给奖励":
		xx.show()	

const rareItem = 15
#当前是否已抽出限定角色标记
var hadUp = false
#从当前池子中获得随机人物
func getRndCha(buff = 0):
	var rngnum = sys.rndRan(1, 1000)
	var rng = ""
	if rngnum <= 5 + buff:
		rng = sys.rndListItem(lv4)
	elif rngnum <= 160 + buff:
		if sys.rndPer(75):
			rng = getRndSpecChaId()
		else:
			rng = sys.rndListItem(lv3)
	else:
		rng = sys.rndListItem(lv1)
	return sys.main.newChara(rng)

#特殊角色池相关
func getRndSpecChaId(isUp = true):
	if azurCtrl.upCha != null && isUp && not hadUp:
		hadUp = true
		return azurCtrl.upCha
	return sys.rndListItem(specChas).id

func getRndSpecChaInfo():
	return sys.rndListItem(specChas)

#从当前池子中获得随机物品
func getRndItem():
	return sys.newItem(itemData.rndPool.rndItem().id)

#创建技能文字特效
func createSkillTextEff(text, position):
	if difficult.step >= 100:
		return null
	var eff = sys.newEff("numHit", position, false, 1)
	eff.setText(text, "#FF0099")
	eff.anim.set_speed_scale(0.2)

#人物跳跃到指定地点
func jump(target, selfCha):
	var mv = Vector2(target.cell.x ,target.cell.y)
	var vs = [Vector2(0,0),Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1),Vector2(1,1),Vector2(-1,1),Vector2(-1,-1),Vector2(1,-1)]
	for i in vs:
		var v = mv+i
		if sys.main.matCha(v) == null && sys.main.isMatin(v):
			if selfCha.setCell(v) :
				var pos = sys.main.map.map_to_world(selfCha.cell)
				ying(pos, selfCha)
				selfCha.position = pos
				selfCha.aiCha = null
				break
#移动特效
func ying(pos, selfCha):
	var l:Vector2 = pos - selfCha.position
	var s = 25
	var rs = preload("res://core/ying.tscn")
	var n = l.length()/s
	for i in range(n):
		var spr = rs.instance()
		sys.main.map.add_child(spr)
		spr.texture =  selfCha.img.texture
		spr.position = selfCha.position + s * (i+1) * l.normalized() - Vector2(selfCha.img.texture.get_width()/2,selfCha.img.texture.get_height())
		spr.init(255/n * i + 100)

#进化单位
func evoCha(cha, id, tmpEvo = true):
	var afterEvoCha
	var waitDel = []
	if not tmpEvo:
		#正常三合一进化，查找场下素材
		var chas = getReadyChas() + getAllChas(2)
		for i in chas:
			if waitDel.size() >= 2:break
			if i.id == cha.id and i != cha and i.get("sacrifice") != false:
				waitDel.append(i)
	if waitDel.size() == 2 or tmpEvo:
		# waitDel.append(cha)
		afterEvoCha = sys.main.newChara(id)
		afterEvoCha.onEvo = true
		var index = waitDel.size() - 1
		while index >= 0:
			delChaOnEvo(waitDel[index])
			index -= 1
		omgCtrl.onEvo(afterEvoCha)
		sys.main.upEvoChara()
	else:
		afterEvoCha = sys.main.evoChara(cha, id)
	if afterEvoCha != null:
		# afterEvoCha.isDrag = true
		if is_instance_valid(cha):
			extendsEvo(afterEvoCha, cha)
	return afterEvoCha


func delChaOnEvo(cha):
	removeAllEquip(cha)
	if cha.get("manualDel") == false:
		cha.manualDel = true
	deleteCha(cha)

#进化后继承属性
func extendsEvo(afterEvoCha, cha):
	var items = []
	for i in cha.items:
		items.append(i)
	var node = cha.get_parent()
	cha.remove()
	afterEvoCha.isItem = cha.isItem
	node.add_child(afterEvoCha)
	if afterEvoCha.lv > 3:
		afterEvoCha.baseId = cha.id
	afterEvoCha.position = cha.position
	afterEvoCha.cell = cha.cell
	afterEvoCha.isDrag = cha.isDrag
	if not afterEvoCha.isItem:
		sys.main.setMatCha(afterEvoCha.cell, afterEvoCha)
	for i in items:
		afterEvoCha.addItem(i)
	sys.main.upLv()
	# afterEvoCheck(cha.id)
	sys.main.upEvoChara()
	sys.main.emit_signal("onEvo", afterEvoCha)
	sys.main.upLv()
	if afterEvoCha.has_method("extendsEvo"):
		afterEvoCha.extendsEvo(cha)
	

func afterEvoCheck(id):
	yield(sys.get_tree().create_timer(0.4), "timeout")
	var chas = []
	for i in getReadyChas() + getAllChas(2):
		if i.id == id:
			chas.append(i)
	if chas.size() < 3:
		for i in chas:
			i.set_sureEvo(false)	

func removeAllEquip(cha):
	var index = cha.items.size()-1
	while index >= 0:
		var item = cha.items[index]
		cha.delItem(item)
		if item.has_method("clearData"):
			item.clearData()
		index -= 1

func deleteCha(cha):
	cha.deleting = true
	var node = cha.get_parent()
	if node != null and cha.isItem:
		node.queue_free()
	else:
		sys.main.delMatChara(cha)

#小型火炮系数
var lightGunRate = [1.1, 0.9, 0.7, 0.8]
#中型火炮系数
var mediumGunRate = [1.2, 1, 0.8, 0.8]
#重型火炮系数
var heavyGunRate = [0.6, 1.1, 1.3, 0.8]
#要塞级火炮系数
var fortressGunRate = [1.2, 1.2, 1.2, 1]

func getRateByGunType(gunType):
	if gunType == "小型":
		return lightGunRate
	elif gunType == "中型":
		return mediumGunRate
	elif gunType == "大型":
		return heavyGunRate
	elif gunType == "要塞级":
		return fortressGunRate

#获得steam玩家名
func getPlayerName():
	if osName == "Android":
		return base.getSetting("userName", "未知安卓玩家")
	return pc.getPlayerName()

func getPlayerId():
	if osName == "Android":return null
	return pc.getPlayerId()
#创建窗口
func createWindowDialog(baseNode, title, size = Vector2(900, 500)):
	if not is_instance_valid(baseNode):return
	var window = WindowDialog.new()
	window.set_size(size)
	window.window_title = title
	baseNode.add_child(window)
	return window
#创建滚动容器
func createScrollContainer(baseNode, size, position):
	var context = ScrollContainer.new()
	context.set_custom_minimum_size(size)
	context.rect_position = position
	baseNode.add_child(context)
	return context

func createHBox(baseNode, position = null):
	var itemBox = HBoxContainer.new()
	baseNode.add_child(itemBox)
	if position != null:
		itemBox.rect_position = position
	return itemBox

func createVBox(baseNode, position = null):
	var itemBox = VBoxContainer.new()
	baseNode.add_child(itemBox)
	if position != null:
		itemBox.rect_position = position
	return itemBox

func createGridContainer(node, size):
	var taskBox = GridContainer.new()
	taskBox.columns = size
	node.add_child(taskBox)
	return taskBox

#获得所有单位，0全部，1敌人，2友军
func getAllChas(team = 0):
	var result = []
	for i in getAllCells(1):
		var cha = sys.main.matCha(i)
		if cha != null:
			if team == 0 || team == 1 && cha.team == 2 || team == 2 && cha.team == 1:
				result.append(cha)
	return result
#创建图片容器
func createTextureRect(file):
	var obj = TextureRect.new()
	obj.set_texture(base.loadImg(path, file))
	return obj

func createImageTexture(file):
	return base.loadImg(path, file)

#获得角色立绘
func getCharaDrawing(cha, checkPlus = true):
	var texture
	var file = drawing.config.get(cha.id)
	if file == null:file = cha.ename
	if file == null:return null
	if plus != null and checkPlus:
		#从补充包中加载立绘
		var index = 1
		var conf = base.getSetting("drawing", {})
		var setting = conf.get(file)
		if setting != null:index = setting
		texture = plus.loadDrawing(file, index)
		if texture != null:
			conf[file] = index
			base.setSetting("drawing", conf)
	if texture == null:
		file = "g_azurlineDrawing/" + file + "1.png"
		texture = createTextureRect(file)
	return texture

#随机获得封面图
func getCoverPic():
	var texture
	if plus != null:
		texture = plus.rndCoverPic()
	return texture

#切换角色立绘
func switchDrawing(cha):
	if plus == null:
		sys.newBaseMsg("提示", "切换立绘需要在创意工坊订阅[碧蓝航线补充包]MOD")
	var index = 1
	var file = drawing.config.get(cha.id)
	if file == null:file = cha.ename
	if file == null:return null
	var conf = base.getSetting("drawing", {})
	var setting = conf.get(file)
	if setting != null:index = setting + 1
	var texture = plus.loadDrawing(file, index)
	if texture == null:
		index = 1
		texture = plus.loadDrawing(file, index)
	if texture != null:
		conf[file] = index
		base.setSetting("drawing", conf)
	else:
		texture = getCharaDrawing(cha, false)
	return texture

var changelog
func readChangeLog():
	if changelog == null:
		if file.file_exists(path+"/changelog.txt"):
			file.open(path+"/changelog.txt",File.READ)
			changelog=file.get_as_text()
			file.close()
			changelog.replace("**","[color=#64a6b7]").replace("##","[/color]")
		else:
			print("更新文档不存在")
			return null
	return changelog

var version:int = 0
func readVersion():
	if version == 0:
		if file.file_exists(path+"/version.txt"):
			file.open(path+"/version.txt",File.READ)
			version = int(file.get_as_text())
			file.close()
	return version

#从cha数组中获得第一个非boss角色
func getFirstFromChas(chas):
	for i in chas:
		if i.get("type") == "BOSS":continue
		return i

var planes = ["cex___plane-97", "cex___plane-99", "cex___plane-BTD1", "cex___plane-Comet", "cex___plane-F6F", "cex___plane-Gale", 
"cex___plane-Meteor", "cex___plane-SB2C", "cex___plane-SeaTooth", "cex___plane-TBF", "cex___plane-Tianshan", "cex___plane-Zero52"]
var planeRare = ["cex___plane-Barracuda-831", "cex___plane-F2A-saqi", "cex___plane-F4U-Ex", "cex___plane-SBD-Ex", "cex___plane-Swordfish-818", "cex___plane-TBD-VT8"]
func getRndPlane(rare = false):
	if rare:
		return sys.rndListItem(planeRare)
	else:
		return sys.rndListItem(planes)

func lineChas(aCell, bCell, num):
	var chas = []
	var aPos = sys.main.map.map_to_world(aCell)
	var bPos = sys.main.map.map_to_world(bCell)
	var n = (bPos - aPos).normalized()
	var oldCell = null
	for i in range(num):
		var ac = sys.main.map.world_to_map(aPos)
		aPos += n * 100
		if oldCell != ac:
			oldCell = ac
			var cha = sys.main.matCha(ac)
			if cha != null:
				chas.append(cha)
			else:
				cha = sys.main.matCha(ac + Vector2(0, 1))
				if cha != null:
					chas.append(cha)
	return chas
#根据cha获得一个随机敌方单位
func getRndEnemy(cha):
	var chas = cha.getAllChas(1)
	if chas == null or chas.empty():
		return null
	else:
		return sys.rndListItem(chas)
#根据cha获得N个随机敌方单位
func getRndEnemys(cha, num):
	var result = []
	var chas = cha.getAllChas(1)
	chas.shuffle()
	for i in range(num):
		if i >= chas.size():break
		result.append(chas[i])
	return result

#根据cha获得一个随机友方单位
func getRndAlly(cha):
	return sys.rndListItem(cha.getAllChas(2))

#根据cha获得N个随机友方单位
func getRndAllys(cha, num):
	var result = []
	var chas = cha.getAllChas(2)
	chas.shuffle()
	for i in range(num):
		if i >= chas.size():break
		result.append(i)
	return result

#对字典指定字段进行加减
func dicPlus(dic, field, num):
	var f = dic.get(field)
	if f == null:
		dic[field] = num
	else:
		dic[field] = f + num
#从字典中进行检索，若没有则返回默认值
func dicGet(dic, field, default):
	var f = dic.get(field)
	if f == null:
		return default
	else:
		return f

#对字典指定字段进行append
func dicAppend(dic, field, obj):
	var f = dic.get(field)
	if f == null:
		dic[field] = [obj]
	else:
		dic[field].append(obj)

func stringToVector(cell):
	if cell is Vector2:return cell
	var x = int(cell.rsplit(",")[0].rsplit("(")[1])
	var y = int(cell.rsplit(",")[1].rsplit(")")[0])
	return Vector2(x, y)
#浮点数截取两位小数
func floatScale(num:float):
	var tmp = int(num * 100)
	return tmp/100.0
#当前是否是移动端
func isMobile():
	return osName == "Android"

func loadScript(name):
	return load("%s/azurline_ctrl/%s.gd" % [chaData.infoDs["cazurlineA"].dir, name]).new()

func getMouseCell():
	var pos = sys.main.map.get_local_mouse_position() + Vector2(sys.main.map.cell_size.x/2,sys.main.map.cell_size.y)
	var cell = sys.main.map.world_to_map(pos)
	return cell

func openHelpWindow(text):
	var helpPop = sys.newMsg("jiangLiMsg")
	helpPop.get_node("Panel/Label").text = "说明"
	# helpPop.print_tree_pretty()
	helpPop.get_node("Panel/Button2").hide()
	var panel = helpPop.get_node("Panel")
	var textBox = RichTextLabel.new()
	textBox.bbcode_enabled = true	
	textBox.bbcode_text = text
	textBox.margin_top = 80
	textBox.margin_left = 50
	textBox.rect_min_size = Vector2(1000,400)
	panel.add_child(textBox)
	helpPop.popup()

#检查舰种数量
var validTypes = ["驱逐", "轻巡", "重巡", "战列", "航母", "辅助"]
func checkCharaType():
	var result = {"驱逐":0, "轻巡":0, "重巡":0, "战列":0, "航母":0, "辅助":0}
	for i in getAllChas(2):
		if i.get("tag") != "azurline" or i.chaName.find("「") == -1 or i.isSumm:continue
		var type = i.chaName.rsplit("「")[1].rsplit("」")[0]
		if validTypes.has(type):dicPlus(result, type, 1)
	return result

#获得角色种族
func getChaType(cha):
	if cha.get("tag") != "azurline" or cha.chaName.find("「") == -1 or cha.isSumm:return null
	return cha.chaName.rsplit("「")[1].rsplit("」")[0]

var validTypeWeight = {"驱逐":1, "轻巡":2, "重巡":3, "战列":4, "航母":5, "辅助":6}
func sortByShipType(a, b):
	return  validTypeWeight.get(a) < validTypeWeight.get(b)

func fillShipTypeDic():
	for i in lv1:
		doFillShipTypeDic(i)
	for i in lv2:
		doFillShipTypeDic(i)
	for i in lv3:
		doFillShipTypeDic(i)
	for i in lv4:
		doFillShipTypeDic(i)

func doFillShipTypeDic(id):
	var cha = sys.main.newChara(id)
	cha._extInit()
	var fromType = cha.chaName.rsplit("「")[1].rsplit("」")[0]
	var typeDic = dicGet(shipTypeDic, fromType, {})
	dicAppend(typeDic, String(cha.lv), cha.id)
	shipTypeDic[fromType] = typeDic
	cha.queue_free()
#是否挑战模式
func isChallengeMode():
	return base.getSetting("challengeMode", false) and difficult.difficult == 7	

func newChaBt(node, id):
	var chaBt = preload("res://ui/itemBt/itemBt.tscn").instance()
	chaBt.id = id
	node.add_child(chaBt)	
	return chaBt

#给玩家新增角色	
func addPlayerCha(id):
	sys.main.player.addCha(sys.main.newChara(id))

#替换节点脚本
func changeScript(node, script):
	var prev_variables = {}
	var skip_variables = ["Script Variables", "script"]
	for property in node.get_property_list():
		var key = property.name
		if not key in skip_variables and key != "":
			prev_variables[key] = node.get(key)
	node.set_script(script)
	for property in prev_variables:
		node.set(property, prev_variables[property])		

func newChara(id, team = 1):
	var cha = null
	if cha == null:
		cha = preload("res://core/chara.tscn").instance()
		cha.set_script(load("{dir}/{id}/{id}.gd".format({id = id, dir = chaData.infoDs[id].dir})))
	cha.id = id
	cha.team = team
	return cha
#是否不占用物品栏的道具
func isExtraItem(item):
	return item.get("itemTag") == "medic" or item.get("itemTag") == "skillbook" or item.get("itemTag") == "tmp"

#是否是潜艇
func isSubMarine(cha):	
	if cha.chaName.find("大青花鱼") > -1 or cha.chaName.find("U47") > -1 or cha.chaName.find("U37") > -1 or cha.chaName.find("U81") > -1:
		return true

#检查我方有多少种潜艇舰娘
func checkSubMarineTypes(cha):
	var types = []
	for i in cha.getAllChas(2):
		if i.chaName.find("大青花鱼") > -1 and not types.has("大青花鱼"):
			types.append("大青花鱼")
		if i.chaName.find("U47") > -1 and not types.has("U47"):
			types.append("U47")
		if i.chaName.find("U37") > -1 and not types.has("U37"):
			types.append("U37")
		if i.chaName.find("U81") > -1 and not types.has("U81"):
			types.append("U81")	
	return types


