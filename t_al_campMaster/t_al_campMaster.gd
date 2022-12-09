extends Talent
var azurCtrl = globalData.infoDs["g_azurline"]
var buffUtil = globalData.infoDs["g_azurlineBuffs"]
var utils = globalData.infoDs["g_azurlineUtils"]
func init():
	name = "阵营特化"
func _connect():
	sys.main.connect("onBattleStart",self,"onBattleStart")
	yield(sys.get_tree().create_timer(0.5), "timeout")
	if azurCtrl.campMaster.empty():
		openWindow()
		sys.main.player.addItem(sys.newItem("i_Hide_al_campProof"))

func onBattleStart():
	for i in sys.main.btChas:
		if i.team == 1:
			if azurCtrl.campMaster.has(i.get("camp")):
				i.addBuff(b_campMaster.new())
			else:
				i.addBuff(b_campMaster2.new())

func get_info():
	return "点此天赋后，选择一个阵营，选择后：\n[color=#BDB76B]指挥官变为该阵营指挥官，获得该阵营特色技能\n我方该阵营舰娘提高10%四维属性\n[color=#DC143C]我方其他阵营舰娘降低80%四维属性\n[color=#C0C0C0]此天赋不需要升级"

var window
func openWindow():
	if not is_instance_valid(window) or not window is WindowDialog:
		buildWindow()
	window.popup_centered()
var config = {"重樱":"cy.png", "皇家":"hj.png", "白鹰":"by.png", "铁血":"tx.png", "碧蓝":"bl.png"}
func buildWindow():
	window = utils.createWindowDialog(sys.main.get_node("ui"), "选择阵营", Vector2(1100, 600))
	window.popup_exclusive = true
	window.get_close_button().hide()
	var hbox = utils.createHBox(window)
	hbox.margin_left = 30
	hbox.margin_top = 150
	
	utils.createRichTextLabel("请选择阵营，选择后，指挥官变为该阵营指挥官，获得该阵营特色技能\n同时我方该阵营舰娘提高10%四维属性，我方其他阵营舰娘降低80%四维属性", window, Vector2(1000, 100), Vector2(30, 50))
	for i in config.keys():
		var vbox = utils.createVBox(hbox)
		var img = utils.createTextureRect("t_al_campMaster/" + config.get(i))
		vbox.add_child(img)
		utils.createItemButton(vbox, self, "选择", "doSelect", [i])

	utils.createRichTextLabel("[color=#DC143C]碧蓝阵营包括：北方联合、自由鸢尾、其他，我方塞壬会受到该天赋属性惩罚", window, Vector2(1000, 100), Vector2(30, 450))

func doSelect(camp):
	if camp == "碧蓝":
		azurCtrl.campMaster.append("北方联合")
		azurCtrl.campMaster.append("自由鸢尾")
		azurCtrl.campMaster.append("其他")
	else:
		azurCtrl.campMaster.append(camp)
	var chas = utils.getAllChas(2) + utils.getReadyChas()
	for i in chas:
		if i.chaName.find("舰队指挥官") > -1:
			i.learnCmdSkill(camp)
			break
	window.hide()
	
class b_campMaster:
	extends Buff
	var buffName = "阵营特化"
	var dispel = 2
	func _init():
		attInit()
		id = "b_campMaster"
		att.atkL = 0.1
		att.mgiAtkL = 0.1
		att.defL = 0.1
		att.mgiDefL = 0.1
		
class b_campMaster2:
	extends Buff
	var buffName = "阵营特化-惩罚"
	var dispel = 2
	func _init():
		attInit()
		id = "b_campMaster2"
		att.atkL = -0.8
		att.mgiAtkL = -0.8
		att.defL = -0.8
		att.mgiDefL = -0.8