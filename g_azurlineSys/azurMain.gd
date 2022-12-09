extends Main
var utils = globalData.infoDs["g_azurlineUtils"]
var base = globalData.infoDs["g_azurlineBase"]
var azurCtrl = globalData.infoDs["g_azurline"]
var siren = globalData.infoDs["g_azurlineSiren"]

var startItemMsgScript = load(self.get_script().get_path().get_base_dir() + "/azurStartItemMsg.gd")
var startMsgScript = load(self.get_script().get_path().get_base_dir() + "/azurStartMsg.gd")
var talentBtnScript = load(self.get_script().get_path().get_base_dir() + "/azurTalentBtn.gd")
var jieSuanScript = load(self.get_script().get_path().get_base_dir() + "/azurJieSuan.gd")
var startItemMsg
var startMsg
var keyboard

func _ready():
	reloadKey()

func init(mode = 0):
	self.mode = mode
	if mode == 1:
		guankaMsg.maxLLv = 6
		player.maxLv = 15

	sys.get_node("/root/topUi").get_tree().connect("node_added", self, "on_topUi_node_added")
	startItemMsg = sys.newMsg("startItemMsg")
	startItemMsg.init()
	startItemMsg.set_size(Vector2(1640, 820))

	startMsg = sys.newMsg("startMsg")
	startMsg.init()
	# base.connect("onStartGame", self, "onStartGame")

func on_topUi_node_added(node):
	if base.getSetting("clearMode", true):
		if node is MsgBaseX and not sys.main.has_node("ui/azurBtnBox"):
			if node.name == "msgBaseX":
				#物品选择窗口
				utils.changeScript(node, startItemMsgScript)
			elif node.name.find("@msgBaseX") > -1:
				#角色选择窗口
				utils.changeScript(node, startMsgScript)

func onStartGame():
	pass

func reloadKey():
	keyboard = utils.loadScript("Keyboard")
	sys.main.get_node("ui").add_child(keyboard)

func loadInfo():
	var file = File.new()
	if file.open("user://data1/main.save", File.READ) == OK:
		var dic = parse_json(file.get_line())
		file.close()
		if dic == null:print_debug("读取存档错误")
		
		guankaMsg.infoSet(dic["guankaDic"])
		player.infoSet(dic["playDic"])
		
	deleteSave()

	chaData.rndPoolRs()
	playerPan.upHp(0)
	if sys.main.has_node("ui/jiaoChen"):
		$ui / jiaoChen.queue_free()

func loadInfoManual():
	var file = File.new()
	if file.open("user://data1/main.save", File.READ) == OK:
		var dic = parse_json(file.get_line())
		file.close()
		if dic == null:print_debug("读取存档错误")
		loadGuankaManual(dic["guankaDic"])
		player.infoSet(dic["playDic"])
		
	deleteSave()

func loadGuankaManual(dic):
	guankaMsg.lvStep = dic["lvStep"]
	guankaMsg.maxLLv = dic["maxLLv"]

func deleteSave():
	var dir = Directory.new()
	dir.remove("user://data1/main.save")
	var dir2 = Directory.new()
	dir2.remove("user://data1/azurlineData.save")
	
func saveInfo():
	#向碧蓝各文件发送save信号
	base.azurSave()

	var file = File.new()
	var dir = Directory.new()
	
	dir.make_dir_recursive("user://data1/")
	var dic = {
		guankaDic = guankaMsg.infoGet(), 
		playDic = player.infoGet(), 
	}

	file.open("user://data1/main.save", File.WRITE)
	file.store_line(to_json(dic))
	file.close()

func saveInfoManual():
	base.azurSave()
	var file = File.new()
	var dir = Directory.new()
	dir.make_dir_recursive("user://data1/")
	var dic = {
		guankaDic = saveGuankaManual(), 
		playDic = player.infoGet(), 
	}

	file.open("user://data1/main.save", File.WRITE)
	file.store_line(to_json(dic))
	file.close()

func saveGuankaManual():
	var lvStep = sys.main.guankaMsg.lvStep - 1
	if sys.main.guanKaBtn.step != 1:
		lvStep -= 1
	var dic = {}
	var i = 0
	for iitem in sys.get_node("/root/topUi/guanKaMsg/ScrollContainer/VBoxContainer").get_children():
		dic[i] = {}
		var j = 0
		for jitem in iitem.get_children():
			dic[i][j] = {type = jitem.type, lv = jitem.lv, lvcs = jitem.lvcs, batType = jitem.batType, lvzb = jitem.lvzb}
			j += 1
		i += 1
	
	var adic = {
		lvStep = lvStep, 
		items = dic, 
		maxLLv = sys.main.guankaMsg.maxLLv
	}
	return adic
	
func upEvoChara():
	yield(sys.get_tree().create_timer(0.3), "timeout")
	var sl = []
	var bl = false
	for i in btGrid.get_children():
		if i.get_child_count() > 0 and i.get_child(0).lv < 4:sl.append(i.get_child(0))
	
	for cha in map.get_children():
		if cha is Chara:
			if cha != null and cha.lv < 4 and cha.team == 1 and cha.isSumm == false:
				sl.append(cha)
				
	var dic = {}
	for i in sl:
		if dic.has(i.id):dic[i.id].append(i)
		else :dic[i.id] = [];dic[i.id].append(i)
	for i in dic.values():
		if i.size() > 3:
			for j in i:
				j.sureEvo = true
				bl = true
		else :for j in i:j.sureEvo = false
	if bl:
		upLv()
		emit_signal("onSureEvo")	

func _on_dpsBtn_pressed():
	azurCtrl.battleStatis()

func upLv(val = 0):
	$ui / player / gold.text = "%s：%dG" % [tr("金币"), player.gold]
	player.renKouVal = chasNum()
	$ui / player / lv.text = "%s：%d | %d/%d" % [tr("等级"), player.lv, player.emp, player.maxEmp]
	$ui / player / renKou.text = "%s：%d/%d" % [tr("人口"), player.renKouVal, player.getRenKou()]

#刷新人口
func upPop():
	$ui / player / renKou.text = "%s：%d/%d" % [tr("人口"), player.renKouVal, player.getRenKou()]


func onCharaDel(cha):
	charaNum[cha.team - 1] = chasNum(cha.team)
	if charaNum[cha.team - 1] <= 0 and not isEnd:
		var flag = failProtect(cha)
		if not flag:
			yield (get_tree().create_timer(1), "timeout")
			battleInit()
			return
		isAiStart = false
		if cha.team == 1:
			isEnd = true
			yield (get_tree().create_timer(1), "timeout")
			sys.newMsg("jieSuan").init(false)
		else :
			yield (get_tree().create_timer(1), "timeout")
			var msg = sys.newMsg("jiangLiMsg")
			msg.init(batType)
			yield (msg, "popup_hide")
			battleInit()

func hitPlayer(cha):
	var eff = sys.newEff("sk_feiDang", cha.global_position, true)
	var pos = Vector2(1250, 350)
	eff._initFlyPos(pos, 800)
	yield (eff, "onReach")
	sys.newEff("huohua", pos, true)
	var ef = sys.newEff("numHit", pos, true)
	ef.lab.text = str(10)
	ef.playWu()
	audio.playSe("hit2")
	if player.hp <= 0 and not isEnd:
		isEnd = true
		sys.newMsg("jieSuan").init(false)

#战败保护机制
func failProtect(cha):
	if cha.team == 1 and (siren.activate or azurCtrl.failProtect > 0 and sys.main.batType != 2):
		if siren.activate:
			siren.challengeFail()
		else:
			azurCtrl.failProtect -= 1
			sys.newBaseMsg("提示", "战斗失败！")
		print("执行BOSS战败保护机制")
		isAiStart = false
		for i in cha.getAllChas(1):
			i.deleteSelf()
		return false
	return true

func battleReady(lvcs, lvzb, batType):
	batChas = lvcs
	self.batType = batType
	chaPool.clear()
	var dChas = []
	var yl = [1, 4, 0, 5, 2, 3]
	var llp = [9, 3, 1, 0]
	for i in lvcs:
		var cha = newChara(i, 2)
		map.add_child(cha)
		var bl = false
		for y in yl:
			for x in range(cha.att.atkRan - 1 + matW / 2, matW):
				if matCha(Vector2(x, y)) == null:
					setMatCha(Vector2(x, y), cha)
					bl = true;break
			if bl:break
		if matCha(cha.cell) != null and cha.cell != Vector2():
			cha.setDire( - 1)
			cha.isDrag = true
			cha.position = map.map_to_world(Vector2(4, 1))
			for j in range(cha.lv):
				var id = chaData.getLvIds(cha.id, j + 1)
				if j < 4 and id.find("cex") == - 1:
					chaPool.addItem(id, llp[j])
			emit_signal("onAddBatChara", cha)
			dChas.append(cha)
		else :
			cha.remove()
	var itemNum = lvzb / 3
	for i in range(itemNum):
		var it = itemData.rndPool.rndItem()
		if it == null:
			sys.randomize()
			it = itemData.rndPool.rndItem()
		var id = it.id
		var item:Item = sys.newItem(id)
		for j in range(100):
			var bl = false
			for k in dChas:
				if k.lv == 2 and k.items.size() < 1 or (k.items.size() < (k.lv - 2)) or j > 50:
					if item.att.maxHp != 0 and (k.attCoe.maxHp > k.attCoe.atk or k.attCoe.maxHp > k.attCoe.mgiAtk):
						k.addItem(item);
						bl = true;
						break;
					elif item.att.atk != 0 and k.attCoe.maxHp < k.attCoe.atk:
						k.addItem(item);
						bl = true;
						break;
					elif item.att.mgiAtk != 0 and k.attCoe.maxHp < k.attCoe.mgiAtk:
						k.addItem(item);
						bl = true;
						break;
					elif k.attCoe.maxHp < k.attCoe.atk:
						k.addItem(item);
						bl = true;
						break;
					elif j > 50 and k.items.size() < 2:
						k.addItem(item);
						bl = true;
						break;
				
			if bl == true:break
				
	lv += 1
	guanKaBtn.setBat()
	emit_signal("onBattleReady")
	upChaCell()

func _input(event):
	if get_global_mouse_position().x < 1325:
		mml = true
	var pos = map.get_local_mouse_position() + Vector2(map.cell_size.x / 2, map.cell_size.y)
	var cell = map.world_to_map(pos)
	if selCha != null:
		var w = matW
		if not sys.test:w = matW / 2
		if cell.x < 0:cell.x = 0;
		if cell.y < 0:cell.y = 0;
		if (pos.y < 630):
			selPos = map.map_to_world(cell) + $scene.position
			selImg.upSpr(selPos)
		else :
			selImg.position.y = - 1000;selImg.position.x = - 1000
		if event is InputEventMouseButton and event.pressed == false and selCha != null:
			if cell.x >= 0 and cell.x < w and cell.y >= 0 and cell.y < matH:
				if selCha.isItem:
					var num = chasNum()
					if num < player.getRenKou() or matCha(cell) != null:
						var muCha = matCha(cell)
						setMatCha(cell)
						var bta = selCha.get_parent()
						bta.remove_child(selCha)
						bta.queue_free()
						var cha = selCha
						map.add_child(cha)
						cha.cell = cell
						cha.position = pos
						cha.isDrag = true
						cha.isItem = false
						setMatCha(cell, cha)
						cha.infoUp()
						if cell.x >= matW / 2:cha.team = 2;else :cha.team = 1
						if muCha != null:
							muCha.get_parent().remove_child(muCha)
							var bt = addBtItem(muCha)
							bt.get_parent().move_child(bt, selCha.get_parent().get_index())
						emit_signal("onPlaceChara", cha)
					else :sys.newBaseMsg("提示", "人口不足")
						
				else :
					var muCha = matCha(cell)
					var muCell = selCha.cell
					setMatCha(selCha.cell)
					setMatCha(cell)
					setMatCha(selCha.cell, muCha)
					setMatCha(cell, selCha)
					if cell.x >= matW / 2:selCha.team = 2;else :selCha.team = 1
			else :
				pos = get_global_mouse_position()
				var grid = $ui / Panel / ScrollContainer / GridContainer
				if pos.y > 600:
					pos = grid.get_local_mouse_position()
					var inx = int(pos.x / (144))
					inx = clamp(inx, 0, grid.get_child_count())
					if selCha.isItem:
						var node = selCha.get_parent()
						node.get_parent().move_child(node, inx)
					else :
						selCha.get_parent().remove_child(selCha)
						var bt = addBtItem(selCha)
						bt.get_parent().move_child(bt, inx)
						setMatCha(selCha.cell)
					
				elif cell == Vector2(5, 2):
					emit_signal("onItemIn", selCha)
			audio.playSe("luo")
			selCha = null
			selImg.hide()
			$scene / bg / xian.hide()
			upLv()
	if selItem != null and event is InputEventMouseButton and event.pressed == false:
		var cha = matCha(cell)
		if cha != null and cha.team == 1:
			selItem.setCha(cha)
			emit_signal("onPlaceItem", selItem.item)
		elif cell == Vector2(5, 2):
			emit_signal("onItemIn", selItem)
		else :
			pos = get_global_mouse_position()
			var grid = $ui / Panel / ScrollContainer / GridContainer
			if pos.y > 650 and grid.get_child_count() > 0:
				pos = grid.get_local_mouse_position()
				var inx = int(pos.x / (144))
				inx = clamp(inx, 0, grid.get_child_count() - 1)
				selItem.setCha(grid.get_child(inx).get_child(0))
				emit_signal("onPlaceItem", selItem.item)
		selItem = null
		audio.playSe("luo")

func battleInit():
	var sl = []
	for x in range(matW):
		for y in range(matH):
			setMatCha(Vector2(x, y), null, true)
	for i in map.get_children():
		if i is Chara:
			sl.append(i)
	var delChas = []
	for cha in sl:
		if cha is Chara:
			if cha.team == 1 and batType == 2 and cha.isDeath and cha.isSumm == false:
				cha.revive()
				cha.att.hp = cha.att.maxHp
			cha.delAllBuff()
			if not cha.isDeath and not cha.isSumm:
				cha.cell = cha.oldCell
				cha.setDire(1)
				setMatCha(cha.cell, cha)
			else :
				if cha.team == 1 and cha.isSumm == false:
					delChas.append(cha)
					cha.cell = cha.oldCell
					
				else :cha.remove()
		
	yield (get_tree().create_timer(1), "timeout")
	var chaPs = [2, 5, 10, 15]
	for cha in delChas:
		if cha.lv <= 3 and false:
			var newId = ""
			if cha.lv > 3:
				newId = cha.baseId
			else :
				newId = chaData.getLvIds(cha.id, cha.lv - 1)
			
			var neff = cha.newEff("numHit")
			neff.setNorPos(cha.sprcPos)
			neff.scale = Vector2(1, 1)
			neff.init(0, cha)
			neff.play("tuiHua")
			
			cha.play("del")
			yield (get_tree().create_timer(0.7), "timeout")
			for i in range(2):
				var feiCha = preload("res://ex/eff/feiCha.tscn").instance()
				topUi.add_child(feiCha)
				feiCha.init(cha, Vector2(20 + 120 * i, 670), newId)
			
			cha.remove()
		else :
			var neff = cha.newEff("numHit")
			neff.setNorPos(cha.sprcPos)
			neff.scale = Vector2(1, 1)
			neff.init(0, cha)
			neff.play("tuiHua")
			hitPlayer(cha)
			cha.revive()
			cha.att.hp = cha.att.maxHp
			player.subHp(chaPs[cha.lv - 1])
	upChaCell()
	if batType == 2:chasPlusHp(2, 2)
	else :chasPlusHp(0.3, 0.6)
	upEvoChara()
	upLv()
	if batType == 2:
		batLLv += 1
		emit_signal("onBossEnd", batLLv)
	if batLLv >= guankaMsg.maxLLv:
		sys.newMsg("jieSuan").init(true)
		emit_signal("onTongGuan", jinJieData.nowLv)
		deleteSave()
	else:
		guanKaBtn.setMap()
	emit_signal("onBattleEnd")

func initSt():
	chaData.rndPoolRs()
	itemData.rndPoolRs()
	guankaMsg.init()
	for i in range(4 + jinJieData.nowLv):
		player.addCha(newChara(chaData.rndLvInfo(1).id))

	sys.main.player.addCha(sys.main.newChara("cex___al-merchant"))
	var upan = sys.newItem("i_Hide_al_oldu")
	upan.num = 2
	upan.clearData()
	sys.main.player.addItem(upan)
	sys.main.player.addCha(sys.main.newChara("cex___al-commander"))
	sys.main.player.addItem(sys.newItem("i_Hide_al_equipBox"))

	upLv()
	if sys.test:
		player.addCha(newChara("cex___7"))
		player.addCha(newChara("ca2"))
		player.addCha(newChara("ca2_1"))
		player.addCha(newChara("ca2_1_1"))
		player.addCha(newChara("ca2_1_2"))
		player.addCha(newChara("ca2_2"))
		player.addCha(newChara("ca2_2_1"))
		player.addCha(newChara("ca2_2_2"))
		player.addCha(newChara("cex___a2"))
		for i in itemData.infos:
			player.addItem(sys.newItem(i.id))