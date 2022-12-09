extends Talent
var azurCtrl = globalData.infoDs["g_azurline"]
var buffUtil = globalData.infoDs["g_azurlineBuffs"]
var utils = globalData.infoDs["g_azurlineUtils"]
func init():
	name = "炮术专精"
func _connect():
	sys.main.connect("onBattleStart",self,"onBattleStart")
	yield(sys.get_tree().create_timer(0.5), "timeout")
	if azurCtrl.gunMaster == null:
		openWindow()

func onBattleStart():
	for i in sys.main.btChas:
		if i.team == 1 && i.get("gunRate") != null && i.gunType == azurCtrl.gunMaster:
			i.addBuff(buffUtil.b_atkR.new(2.5))

func get_info():
	return "可选择提高小/中/大口径火炮25%伤害\n[color=#DC143C]此天赋不需要升级"

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
	vbox.margin_top = 150
	var guns = ["小型", "中型", "大型"]
	utils.createRichTextLabel("请选择主炮口径专精，选择后，该类型主炮口径的舰娘将获得25%伤害加成", window, Vector2(500, 100), Vector2(30, 50))
	for i in guns:
		var hbox = utils.createHBox(vbox)
		utils.createRichTextLabel(i, hbox, Vector2(300, 50))
		utils.createItemButton(hbox, self, "选择", "doSelect", [i])

func doSelect(gunType):
	azurCtrl.gunMaster = gunType
	window.hide()