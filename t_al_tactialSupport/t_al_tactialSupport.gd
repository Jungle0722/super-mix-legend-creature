extends Talent

var utils = globalData.infoDs["g_azurlineUtils"]
var azurCtrl = globalData.infoDs["g_azurline"]
var difficult = globalData.infoDs["g_azurlineDifficult"]
var buffUtil = globalData.infoDs["g_azurlineBuffs"]
func init():
	name = "战术支援"
func _connect():
	var btn = utils.createItemButton(sys.main.get_node("ui"), self, "战术支援", "openWindow", [], Vector2(1300, 600))
	btn.name = "tactialSupportBtn"
	if sys.main.get_node("ui").has_node("specialFleetBtn"):
		btn.rect_position.y -= 48
	sys.main.connect("onBattleStart",self,"onBattleStart")
	
	yield(sys.get_tree().create_timer(0.5), "timeout")
	if azurCtrl.selectedTactialSup != null:
		buildWindow()
		refreshWindow()

func get_info():
	return "开启战术支援：可以学习与使用主动技能\n点此天赋后，点击右下角的[战术支援]按钮查看该模式详情\n[color=#DC143C]此天赋不需要升级"

func onBattleStart():
	if azurCtrl.selectedTactialSup == null:return
	if azurCtrl.tactialSupportCd < 3:
		azurCtrl.tactialSupportCd += 1
		if azurCtrl.tactialSupportCd >= 3:
			skillBtn.disabled = false

var window
var learnBtn
var skillBtn
var resetBtn
var selSkWindow
var skillLabel
func openWindow():
	if not is_instance_valid(window) or not window is WindowDialog:
		buildWindow()
	refreshWindow()
	window.popup_centered()

func buildWindow():
	window = utils.createWindowDialog(sys.main.get_node("ui"), "战术支援", Vector2(600, 400))
	var context = utils.createScrollContainer(window, Vector2(550, 450), Vector2(30, 100))
	context.name = "context"
	utils.createItemButton(window, utils, "说明", "openHelpWindow", [guideText], Vector2(30, 30))

	learnBtn = utils.createItemButton(window, self, "学习技能", "learnSkill", [], Vector2(200, 150))
	resetBtn = utils.createItemButton(window, self, "重置", "reset", [], Vector2(110, 30))
	resetBtn.hide() 

	skillLabel = utils.createRichTextLabel("", context, Vector2(520, 450))
	skillLabel.hide()

	if azurCtrl.selectedTactialSup != null:
		doLearnSkill(azurCtrl.selectedTactialSup)

var guideText = """
[color=#BDB76B]战术支援：[/color]
点击[学习]按钮学习主动技能
学习技能后，点击左下角[主动技能]按钮，快捷键B，即可使用技能
可花费200金重置技能，重置技能后，技能等级-1
每使用5次，技能等级+1，最高5级
"""

func refreshWindow():
	if azurCtrl.selectedTactialSup == null:return
	var context = window.get_node("context")

	resetBtn.show()
	skillLabel.show()
	learnBtn.hide()
	if is_instance_valid(skillBtn):
		skillBtn.show()
		skillBtn.text = azurCtrl.selectedTactialSup + "(B)"

	var config = skillConfig.get(azurCtrl.selectedTactialSup)
	var skText
	if config.call == "buHuo":
		skText = config.text
	else:	
		skText = config.text%(config.p1 + config.p2 * (azurCtrl.tactialSupportLv - 1))
	skillLabel.bbcode_text = "当前技能：\n[color=#FFA500][{skName}][/color]:[color=#25BCAF]{skText}[/color]\n等级：{skLv}/5".format({"skName":azurCtrl.selectedTactialSup, "skText":skText, "skLv":azurCtrl.tactialSupportLv})

var tmpSkOpt = []
func learnSkill():
	if is_instance_valid(selSkWindow) and selSkWindow is WindowDialog: 
		selSkWindow.queue_free()
		selSkWindow = null
	selSkWindow = utils.createWindowDialog(window, "技能选择", Vector2(900, 400))
	var context = utils.createVBox(selSkWindow)
	context.margin_top = 50
	context.margin_left = 50
	var sks = []
	if tmpSkOpt.empty():
		var selected = []
		for i in range(3):
			var sk = sys.rndListItem(skillConfig.keys())
			while tmpSkOpt.has(sk) or utils.isMobile() and skillConfig.get(sk).useMouse:
				sk = sys.rndListItem(skillConfig.keys())
			sks.append(sk)
			tmpSkOpt.append(sk)
	for i in range(3):
		var hbox = utils.createHBox(context)
		var name = tmpSkOpt[i]
		var sk = skillConfig.get(name)
		if sk.call == "buHuo":
			utils.createRichTextLabel(utils.consts.colorGold + "[{1}]:{3}".format({"1":name,"3":sk.text}), hbox, Vector2(750, 50))
		else:
			utils.createRichTextLabel(utils.consts.colorGold + "[{1}]:{3}".format({"1":name,"3":sk.text%[sk.p1]}), hbox, Vector2(750, 50))
		utils.createItemButton(hbox, self, "选择", "doLearnSkill", [name])

	selSkWindow.popup_centered()

func doLearnSkill(name):
	azurCtrl.selectedTactialSup = name
	if is_instance_valid(selSkWindow) and selSkWindow is WindowDialog: 
		selSkWindow.hide()
	learnBtn.hide()
	if skillBtn == null:
		createSkillBtn()
	refreshWindow()

func reset():
	if sys.main.player.gold < 200:
		sys.newBaseMsg("提示", "重置失败：金币不足！")
		return
	sys.main.player.plusGold(-200)

	azurCtrl.selectedTactialSup = null
	if azurCtrl.tactialSupportLv > 1:
		azurCtrl.tactialSupportLv -= 1
	else:
		azurCtrl.tactialSupportExp = 0
	skillLabel.hide()
	learnBtn.show()
	resetBtn.hide()
	tmpSkOpt.clear()
	skillBtn.hide()

func createSkillBtn():
	skillBtn = utils.createItemButton(sys.main.get_node("ui"), self, azurCtrl.selectedTactialSup + "(B)", "castSkill", [], Vector2(200, 625))
	utils.addShotCutToBtn(skillBtn, KEY_B)

func castSkill():
	if not sys.main.isAiStart:return
	print("施放主动技能：%s"%[azurCtrl.selectedTactialSup])
	var config = skillConfig.get(azurCtrl.selectedTactialSup)
	if not call(config.call):
		return
	if azurCtrl.tactialSupportLv < 4:
		azurCtrl.tactialSupportExp += 1
		if azurCtrl.tactialSupportExp >= 4:
			azurCtrl.tactialSupportExp = 0
			azurCtrl.tactialSupportLv += 1
	azurCtrl.tactialSupportCd = 0
	skillBtn.disabled = true

func getSkillEff(config):
	return config.p1 + config.p2 * (azurCtrl.tactialSupportLv - 1)

#战术抢修
func qiangXiu():
	var config = skillConfig.get(azurCtrl.selectedTactialSup)
	for i in utils.getAllChas(2):
		i.plusHp(i.att.maxHp * getSkillEff(config) * 0.01)
	return true

#战术强化
func qiangHua():
	var config = skillConfig.get(azurCtrl.selectedTactialSup)
	for i in utils.getAllChas(2):
		i.addBuff(buffUtil.b_atkR.new(getSkillEff(config)*0.1, 5))
	return true

#战术打击
func daJi():
	var config = skillConfig.get(azurCtrl.selectedTactialSup)
	var eff = getSkillEff(config) * 0.01
	for i in utils.getAllChas(1):
		i.hurtChara(i, i.att.maxHp * eff, Chara.HurtType.REAL, Chara.AtkType.EFF)
	return true

#战术装甲
func zhuangJia():
	var config = skillConfig.get(azurCtrl.selectedTactialSup)
	for i in utils.getAllChas(2):
		i.addBuff(buffUtil.b_mianYi_phy.new(getSkillEff(config)))
	return true

#战术魔抗
func moKang():
	var config = skillConfig.get(azurCtrl.selectedTactialSup)
	for i in utils.getAllChas(2):
		i.addBuff(buffUtil.b_mianYi_mgi.new(getSkillEff(config)))
	return true

#战术震慑
func zhenShe():
	var config = skillConfig.get(azurCtrl.selectedTactialSup)
	for i in utils.getAllChas(1):
		i.addBuff(buffUtil.b_xuanYun.new(getSkillEff(config)))
	return true

#战术针对
func zhenDui():
	var config = skillConfig.get(azurCtrl.selectedTactialSup)
	var cell = utils.getMouseCell()
	if not sys.main.isMatin(cell):
		return false
	var cha = sys.main.matCha(cell)
	if cha == null or cha.team == 1 or not cha.has_method("forceHurtSelf"):
		return false
	var eff = getSkillEff(config) * 0.01
	if cha.get("type") == "BOSS":
		eff *= 0.25
	cha.forceHurtSelf(cha.att.maxHp * eff)
	return true

#战术捕获
func buHuo():
	var config = skillConfig.get(azurCtrl.selectedTactialSup)
	var cell = utils.getMouseCell()
	if not sys.main.isMatin(cell):
		return false
	var cha = sys.main.matCha(cell)
	if cha == null or cha.team == 1 or not cha.has_method("forceHurtSelf") or cha.isSumm or cha.get("type") == "BOSS":
		return false
	var eff = getSkillEff(config)
	var p = 0
	match cha.lv:
		1:p = 45
		2:p = 21
		3:p = 6
		4:p = 1.5
	p *= eff
	if cha.att.hp/cha.att.maxHp < 0.5:
		p *= 2
	if sys.rndPer(p):
		sys.newBaseMsg("提示", "捕获成功！，获得角色：[color=#DC143C]%s"%cha.chaName)
		sys.main.player.addCha(sys.main.newChara(cha.id))
	else:
		sys.newBaseMsg("提示", "捕获失败！")
	return true

var skillConfig = {
	"战术抢修":{
		"text":"立即恢复全场友方单位[%d%%]血量",
		"p1":50,#1级数值
		"p2":10,#每级提升数值
		"useMouse":false,
		"call":"qiangXiu",
	},
	"战术强化":{
		"text":"5秒内我方单位提高[%d%%]伤害",
		"p1":50,#1级数值
		"p2":10,#每级提升数值
		"useMouse":false,
		"call":"qiangHua",
	},
	"战术打击":{
		"text":"立即对所有敌方单位造成血上限[%d%%]真实伤害",
		"p1":20,#1级数值
		"p2":10,#每级提升数值
		"useMouse":false,
		"call":"daJi",
	},
	"战术装甲":{
		"text":"%d秒内我方全体免疫物理伤害",
		"p1":5,#1级数值
		"p2":1,#每级提升数值
		"useMouse":false,
		"call":"zhuangJia",
	},
	"战术魔抗":{
		"text":"%d秒内我方全体免疫魔法伤害",
		"p1":5,#1级数值
		"p2":1,#每级提升数值
		"useMouse":false,
		"call":"moKang",
	},
	"战术震慑":{
		"text":"敌方全体眩晕%d秒",
		"p1":3,#1级数值
		"p2":1,#每级提升数值
		"useMouse":false,
		"call":"zhenShe",
	},
	"战术针对":{
		"text":"对鼠标指定位置的单位造成[目标血量%d%%]的真实伤害(无视减伤，对塞壬效果降低75%%)",
		"p1":60,#1级数值
		"p2":10,#每级提升数值
		"useMouse":true,
		"call":"zhenDui",
	},
	"战术捕获":{
		"text":"捕获鼠标指定位置的敌人，目标血量、等级越低，成功率越高(对塞壬、召唤物无效)",
		"p1":1,#1级数值
		"p2":1,#每级提升数值
		"useMouse":true,
		"call":"buHuo",
	},
	# "战术集火":{
	# 	"text":"标记鼠标指定位置的敌人，使其获得%d层<暴露>，并使所有射程内的我方单位集火攻击他",
	# 	"p1":1,#1级数值
	# 	"p2":1,#每级提升数值
	# 	"useMouse":true,
	# 	"call":"jiHuo",
	# },
	# "战术误导":{
	# 	"text":"标记鼠标指定位置的敌人，使其周围2格的所有敌方单位(玩家的敌方)将攻击目标转为他，持续%d秒",
	# 	"p1":1,#1级数值
	# 	"p2":1,#每级提升数值
	# 	"useMouse":true,
	# 	"call":"wuDao",
	# },
}



