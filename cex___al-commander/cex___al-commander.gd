extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「少尉」舰队指挥官"   #角色的名称
	attCoe.maxHp = 3
	attCoe.atk = 2
	attCoe.mgiAtk = 2
	attCoe.def = 2
	attCoe.mgiDef = 2
	attCoe.atkRan = 4
	atkEff = "atk_gongJian"
	lv = 1
	evos = ["cex___al-commander2"]
	type = "cmd"
	# addSkill("学习技能以填充此栏位", "空指挥官技能槽")
	addSkill("学习技能以填充此栏位", "空技能槽")
	addSkill("学习技能以填充此栏位", "空技能槽")
	addSkill("学习技能以填充此栏位", "空技能槽")
	addSkill("学习技能以填充此栏位", "空技能槽")
	addSkillTxt("[color=#C0C0C0]该角色会随着实战不断的变强，详情查看MOD说明")
	initCmd()
	canCopy = false
	if prefer == null:
		prefer = "cmdr"
	
var rankDic = {1:"少尉",2:"中尉",3:"上尉",4:"少校",5:"中校",6:"上校",7:"少将",8:"中将",9:"上将",10:"元帅"}
#1-10 军衔
var rank:int = 1
var cmdExp:int = 0
var battleNum:int = 0
var rndAttSel = []
var skillSlots = {0:null, 1:null, 2:null, 3:null}
var cmdSkill
#指挥官技能加成
var cmdSkillBonus:int = 1
var cmdSkillLv:int = 4
func initCmd():
	chaName = "「%s」舰队指挥官"%rankDic.get(rank)
	for i in skillSlots.keys():
		var sk = skillSlots.get(i)
		if sk != null:
			addSkill(sk.text, sk.sname, null, null, i)
	if cmdSkill != null:
		if skillStrs.size() == 5:
			addSkill(cmdSkill.text, cmdSkill.sname)
		else:
			addSkill(cmdSkill.text, cmdSkill.sname, null, null, 5)

func _onBattleEnd():
	._onBattleEnd()
	cmdExp += 1
	if azurCtrl.commanderTraining and sys.rndPer(35):
		cmdExp += 1
	battleNum += 1
	if cmdExp >= 9 && rank < 10:
		rank += 1
		cmdExp = 0
		chaName = "「%s」舰队指挥官"%rankDic[rank]
		sys.newBaseMsg("通知", "指挥官已晋升为%s，可前往加点"%rankDic.get(rank))
		if rank == 4 || rank == 7 || rank == 10:
			level += 1
			var cha = utils.evoCha(self, evos[0])
			cha.rank = rank
			cha.cmdExp = cmdExp
			cha.battleNum = battleNum
			cha.rndAttSel = rndAttSel
			cha.level = level
			cha.prefer = prefer
			cha.attEx = attEx
			cha.camp = camp
			for i in skillSlots.keys():
				var sk = skillSlots.get(i)
				if sk != null:
					cha.skillSlots[i] = skillPool.getSkill(sk.sid, cmdSkillLv)
					cha.skillSlots[i].setCha(cha)
					cha.addSkill(sk.text, sk.sname)
			if cmdSkill != null:
				var sk
				if camp == "其他":
					sk = skillPool.getCmdSkill("碧蓝")
				else:
					sk = skillPool.getCmdSkill(camp)
				sk.setCha(cha)
				cha.cmdSkill = sk
				cha.addSkill(sk.text, sk.sname)
			for i in cha.rndAttSel:
				cha.setAtt(i)
			cha.initCmd()
			cha.upAtt()
			return
	updateAtt()

func updateAtt():
	updateTmpAtt("maxHp", 30)
	if azurCtrl.commanderTraining:
		updateTmpAtt("maxHp", 20)
		updateTmpAtt("def", 4)
		updateTmpAtt("mgiDef", 4)
		updateTmpAtt("atk", 4)
		updateTmpAtt("mgiAtk", 4)
#角色当前基础属性文本
var charaBaseText = null
func chaInfo(cha):
	yield(cha.reTimer(0.05),"timeout")
	chaInfoWindow = sys.get_node("/root/topUi/charaInfoMsg")
	var txt = chaInfoWindow.get_node("txt")
	var split = txt.bbcode_text.rsplit("\n")
	var res = ""
	for i in range(split.size()):
		if i == 0:
			res += split[i] + "            [color=#FFA500]击杀[/color]：{0}       [color=#FFA500]阵营[/color]：{1}\n".format({"0":cha.killNum, "1":camp})
		elif i == 1:
			res += split[i] + "  闪避：{0}%\n".format({"0":int(cha.att.dod*100)})
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
	charaBaseText = res
	refreshChaSkillText()
	txt.margin_top = 20
	var btnPos = Vector2(500, 600)
	chaInfoWindow.get_node("Button").hide()
	btnPos.x += 110
	utils.createItemButton(chaInfoWindow, utils, "脱下装备", "removeAllEquip", [cha], btnPos)
	if rndAttSel.size() < rank - 1:
		btnPos.x += 110
		utils.createItemButton(chaInfoWindow, self, "属性加点", "attDialog", [chaInfoWindow], btnPos)
	btnPos.x += 110
	utils.createItemButton(chaInfoWindow, self, "学习技能", "skillWindow", [chaInfoWindow], btnPos)
	#倾向选择
	var hbox = HBoxContainer.new()
	utils.createLabel("技能倾向：", hbox)
	var preferBtn = OptionButton.new()
	preferBtn.add_item("无倾向", 0)
	preferBtn.add_item("T", 1)
	preferBtn.add_item("物理", 2)
	preferBtn.add_item("法术", 3)
	preferBtn.add_item("辅助", 4)
	hbox.add_child(preferBtn)
	btnPos.x += 130
	btnPos.y += 10
	hbox.rect_position = btnPos
	chaInfoWindow.add_child(hbox)
	preferBtn.connect("item_selected", self, "switchPrefer", [preferBtn])
	preferBtn.select(preferMap.get(prefer))

func refreshChaSkillText():
	var txt = sys.get_node("/root/topUi/charaInfoMsg/txt")
	var res = ""
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
	txt.bbcode_text = charaBaseText + res

var preferMap = {"cmdr":0, "cmdt":1, "cmdad":2, "cmdap":3, "cmdsup":4}
func switchPrefer(index, btn):
	match btn.get_selected_id():
		0:
			prefer = "cmdr"
		1:
			prefer = "cmdt"
		2:
			prefer = "cmdad"
		3:
			prefer = "cmdap"
		4:
			prefer = "cmdsup"

#=================属性提升选项=================
var attOpts = [
	{"text":"攻击+15%", "value":0.15, "field":["atkL"]},
	{"text":"法强+15%", "value":0.15, "field":["mgiAtkL"]},
	{"text":"双防+20%", "value":0.2, "field":["defL", "mgiDefL"]},
	{"text":"暴击、爆伤+20%", "value":0.2, "field":["cri", "criR"]},
	{"text":"攻速+30%", "value":0.3, "field":["spd"]},
	{"text":"冷却速度+15%", "value":0.15, "field":["cd"]},
	{"text":"闪避+20%", "value":0.20, "field":["dod"]},
	{"text":"血量+20%", "value":0.20, "field":["maxHpL"]},
	{"text":"吸血+35%", "value":0.35, "field":["suck", "mgiSuck"]}
]
var chaInfoWindow
var optWindow
var skillWindow
var selSkWindow
#打开技能UI
func skillWindow(node):
	if is_instance_valid(skillWindow) and skillWindow is WindowDialog: 
		skillWindow.queue_free()
		skillWindow = null
	skillWindow = utils.createWindowDialog(node, "学习技能", Vector2(1150, 450))
	var context = VBoxContainer.new()
	context.margin_top = 50
	context.margin_left = 50
	skillWindow.add_child(context)

	#普通技能槽
	for i in skillSlots.keys():
		var box = utils.createHBox(context)
		var lb = utils.createRichTextLabel("", box, Vector2(1000, 50))
		var slot = skillSlots.get(i)
		if i > level - 1:
			lb.bbcode_text = "当前未满足学习条件"
		else:
			if slot == null:
				lb.bbcode_text = utils.consts.colorGold + "可学习随机技能"
				utils.createItemButton(box, self, "学习", "learnSkill", [i])
			else:
				lb.bbcode_text = "[{1}]:{3}".format({"1":slot.sname,"3":slot.text})
				utils.createItemButton(box, self, "重置", "resetSkill", [i, node])
	skillWindow.popup_centered()

#学习指挥官阵营技能
func learnCmdSkill(camp):
	if camp == "碧蓝":
		self.setCamp("其他")
	else:
		self.camp = camp
	var sk = skillPool.getCmdSkill(camp)
	sk.setCha(self)
	cmdSkill = sk
	addSkill(sk.text, sk.sname)
	# refreshChaSkillText()

#弹出技能选择
var tmpSkOpt = []
func learnSkill(index):
	if is_instance_valid(selSkWindow) and selSkWindow is WindowDialog: 
		selSkWindow.queue_free()
		selSkWindow = null
	selSkWindow = utils.createWindowDialog(skillWindow, "技能选择", Vector2(1150, 400))
	var context = VBoxContainer.new()
	context.margin_top = 50
	context.margin_left = 50
	selSkWindow.add_child(context)
	var sks = []
	if tmpSkOpt.empty():
		var selected = []
		for i in skillSlots.values():
			if i != null:
				selected.append(i.sid)

		for i in range(4):
			var sk = skillPool.getRandomSkill(cmdSkillLv, prefer)
			while sks.has(sk.sid) or selected.has(sk.sid):
				sk = skillPool.getRandomSkill(cmdSkillLv, prefer)
			sks.append(sk.sid)
			tmpSkOpt.append(sk)
	for i in range(4):
		var hbox = utils.createHBox(context)
		var sk = tmpSkOpt[i]
		utils.createRichTextLabel(utils.consts.colorGold + "[{1}]:{3}".format({"1":sk.sname,"3":sk.text}), hbox, Vector2(1000, 50))
		utils.createItemButton(hbox, self, "选择", "doLearnSkill", [sk, index])

	selSkWindow.popup_centered()

#学习技能
var color2 = ["[color=#DC143C]","[color=#E6E6FA]","[color=#00CED1]","[color=#FF00FF]","[color=#BDB76B]"]
func doLearnSkill(sk, index):
	tmpSkOpt.clear()
	selSkWindow.hide()
	skillWindow.hide()
	skillSlots[index] = sk
	addSkill(sk.text, sk.sname, null, null, index)
	refreshChaSkillText()
	sk.setCha(self)

#重置技能
func resetSkill(index, node):
	var window = utils.createWindowDialog(node, "提示", Vector2(600, 400))
	window.popup_exclusive = true
	window.get_close_button().hide()
	var lb = utils.createRichTextLabel("点击确定，消耗100金重置此技能", window, Vector2(500, 300))
	if azurCtrl.commanderTraining:
		lb.bbcode_text = "点击确定，消耗15金重置此技能"
	lb.margin_top = 50
	lb.margin_left = 50
	utils.createItemButton(window, self, "确定", "doResetSkill", [index, window], Vector2(200, 300))
	utils.createItemButton(window, self, "取消", "doResetSkill2", [window], Vector2(300, 300))
	window.popup_centered()
#确定重置技能
func doResetSkill(index, window):
	window.hide()
	# chaInfoWindow.hide()
	skillWindow.hide()
	skillSlots[index].remove()
	skillSlots[index] = null
	# skillStrs[index] = "[空技能槽]-学习技能以填充此栏位"
	if not azurCtrl.commanderTraining:
		sys.main.player.plusGold(-100)
	else:
		sys.main.player.plusGold(-15)

	addSkill("学习技能以填充此栏位", "空技能槽", null, null, index)
	refreshChaSkillText()

#取消重置技能
func doResetSkill2(window):
	window.hide()
	
#打开属性加点UI
var tmpAttOpts = []
func attDialog(node):
	if rndAttSel.size() >= rank - 1:
		sys.newBaseMsg("通知", "当前无法加点，请继续努力提升军衔")
		return
	if is_instance_valid(optWindow) and optWindow is WindowDialog: 
		optWindow.queue_free()
		optWindow = null
	optWindow = utils.createWindowDialog(node, "属性加点", Vector2(600, 300))
	var context = VBoxContainer.new()
	context.margin_top = 50
	context.margin_left = 50
	optWindow.add_child(context)
	
	attOpts.shuffle()
	if tmpAttOpts.size() == 0:
		for i in range(4):
			tmpAttOpts.append(attOpts[i])

	for i in range(4):
		var opt = tmpAttOpts[i]
		var hbox = utils.createHBox(context)
		utils.createRichTextLabel(utils.consts.colorGold + opt.text, hbox, Vector2(400, 50))
		utils.createItemButton(hbox, self, "选择", "selAtt", [opt])
	optWindow.popup_centered()

func selAtt(opt):
	tmpAttOpts.clear()
	rndAttSel.append(opt)
	optWindow.hide()
	setAtt(opt)

func setAtt(opt):
	for i in opt.field:
		attInfo.set(i, attInfo.get(i) + opt.value)
	upAtt()
	
func toJson():
	var json = .toJson()
	json["cmdExp"] = cmdExp
	json["battleNum"] = battleNum
	json["rndAttSel"] = rndAttSel
	json["rank"] = rank
	json["camp"] = camp
	for i in skillSlots.keys():
		if skillSlots.get(i) != null:
			json["cmdSk%d"%i] = skillSlots.get(i).sid
	if cmdSkill != null:
		json["cmdskId"] = cmdSkill.sid
	return json

func fromJson(json, setCell = true):
	.fromJson(json)
	cmdExp = json.get("cmdExp")
	battleNum = json.get("battleNum")
	rndAttSel = json.get("rndAttSel")
	camp = json.get("camp")
	rank = json.get("rank")
	initCmd()
	# chaName = json.get("chaName")
	updateAtt()
	for i in rndAttSel:
		setAtt(i)
	#复原技能
	if json.get("cmdSk0") != null:
		var sk = skillPool.getSkill(int(json.get("cmdSk0")), cmdSkillLv)
		skillSlots[0] = sk
		addSkill(sk.text, sk.sname, null, null, 0)
		sk.setCha(self)
	if json.get("cmdSk1") != null:
		var sk = skillPool.getSkill(int(json.get("cmdSk1")), cmdSkillLv)
		skillSlots[1] = sk
		addSkill(sk.text, sk.sname, null, null, 1)
		sk.setCha(self)
	if json.get("cmdSk2") != null:
		var sk = skillPool.getSkill(int(json.get("cmdSk2")), cmdSkillLv)
		skillSlots[2] = sk
		addSkill(sk.text, sk.sname, null, null, 2)
		sk.setCha(self)
	if json.get("cmdSk3") != null:
		var sk = skillPool.getSkill(int(json.get("cmdSk3")), cmdSkillLv)
		skillSlots[3] = sk
		addSkill(sk.text, sk.sname, null, null, 3)
		sk.setCha(self) 
	
	if json.get("cmdskId") != null:
		var c = camp
		if c == "其他":
			c = "碧蓝"
		learnCmdSkill(c)

	# infoUp()


