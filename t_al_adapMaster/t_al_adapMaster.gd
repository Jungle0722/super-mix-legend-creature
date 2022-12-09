extends Talent
var azurCtrl = globalData.infoDs["g_azurline"]
var buffUtil = globalData.infoDs["g_azurlineBuffs"]
var utils = globalData.infoDs["g_azurlineUtils"]
func init():
	name = ""
func _connect():
	sys.main.connect("onBattleStart",self,"onBattleStart")
	yield(sys.get_tree().create_timer(0.5), "timeout")
	if azurCtrl.apadMaster == null:
		openWindow()

func onBattleStart():
	for i in sys.main.btChas:
		if i.team == 1:
			i.addBuff(b_adapMaster.new())

func get_info():
	return "点此天赋时，二选一：\n[color=#33ff33]我方舰娘造成的魔法伤害降低50%，造成的物理伤害提高40%\n我方舰娘造成的物理伤害降低50%，造成的魔法伤害提高40%[/color]\n[color=#DC143C]此天赋不需要升级"

var window
func openWindow():
	if not is_instance_valid(window) or not window is WindowDialog:
		buildWindow()
	window.popup_centered()

func buildWindow():
	window = utils.createWindowDialog(sys.main.get_node("ui"), "选择专精", Vector2(600, 400))
	window.popup_exclusive = true
	window.get_close_button().hide()
	var vbox = utils.createVBox(window)
	vbox.margin_left = 30
	vbox.margin_top = 30

	var guns = ["魔法专精", "武艺专精"]
	utils.createRichTextLabel("[color=#BDB76B]魔法专精：我方舰娘造成的物理伤害降低50%，造成的魔法伤害提高40%[/color]\n[color=#DC143C]武艺专精：我方舰娘造成的魔法伤害降低50%，造成的物理伤害提高40%[/color]", window, Vector2(500, 200), Vector2(30, 150))
	for i in guns:
		var hbox = utils.createHBox(vbox)
		utils.createRichTextLabel(i, hbox, Vector2(300, 50))
		utils.createItemButton(hbox, self, "选择", "doSelect", [i])

func doSelect(m):
	azurCtrl.apadMaster = m
	window.hide()

class b_adapMaster:
	extends Buff
	var buffName = "魔武专精"
	var dispel = 2
	var azurCtrl = globalData.infoDs["g_azurline"]
	func _init():
		attInit()
		id = "b_adapMaster"
	func _connect():
		masCha.connect("onAtkChara",self,"run")
		masCha.connect("onHurt",self,"onHurt")
	func run(atkInfo):
		if azurCtrl.apadMaster == "魔法专精":
			if atkInfo.hurtType == Chara.HurtType.PHY:
				atkInfo.hurtVal *= 0.5
			elif atkInfo.hurtType == Chara.HurtType.MGI:
				atkInfo.hurtVal *= 0.4
		if azurCtrl.apadMaster == "武艺专精":
			if atkInfo.hurtType == Chara.HurtType.PHY:
				atkInfo.hurtVal *= 0.4
			elif atkInfo.hurtType == Chara.HurtType.MGI:
				atkInfo.hurtVal *= 0.5