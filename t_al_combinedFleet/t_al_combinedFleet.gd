extends Talent
var utils = globalData.infoDs["g_azurlineUtils"]
func init():
	name = "联合舰队"
func _connect():
	sys.main.connect("onBattleStart",self,"run")
	sys.main.connect("onPlaceChara",self,"convertCha")

func convertCha(cha):
	if cha.get_parent() is TileMap and cha.team == 1:
		var charas = utils.checkCharaType()
		var flag = false
		for i in charas.keys():
			if charas.get(i) > 2:
				sys.newBaseMsg("提示", "检测到我方场上%s舰娘超过2个，将受到极大的属性惩罚！"%i)
				flag = true
				break
		if not flag:
			#检查塞壬数量
			var sirenNum = 0
			for i in utils.getAllChas(2):
				if i.get("type") == "siren":
					sirenNum += 1
			if sirenNum > 2:
				sys.newBaseMsg("提示", "检测到我方场上%s舰娘超过2个，将受到极大的属性惩罚！"%"塞壬")

func run():
	var charas = utils.checkCharaType()
	var flag = false
	for i in charas.keys():
		if charas.get(i) > 2:
			sys.newBaseMsg("提示", "检测到我方场上%s舰娘超过2个，将受到极大的属性惩罚！"%i)
			flag = true
			break
	if not flag:
		#检查塞壬数量
		var sirenNum = 0
		for i in utils.getAllChas(2):
			if i.get("type") == "siren":
				sirenNum += 1
		if sirenNum > 2:
			sys.newBaseMsg("提示", "检测到我方场上%s舰娘超过2个，将受到极大的属性惩罚！"%"塞壬")
			flag = true

	if flag:
		for i in sys.main.btChas:
			if i.team == 1:
				i.addBuff(b_al_combinedFleet.new())
	else:
		for i in sys.main.btChas:
			if i.team == 1 and i.get("tag") == "azurline":
				i.updateTmpAtt("atk", 5)
				i.updateTmpAtt("mgiAtk", 5)
				i.updateTmpAtt("def", 5)
				i.updateTmpAtt("mgiDef", 5)

func get_info():
	return "[color=#DC143C]我方场上每个舰种的舰娘不超过2个时，所有角色每回合永久提高5点四维属性[/color]\n任意舰种超过2个，则我方所有角色降低80%四维属性\n塞壬也算一个舰种，指挥官独立不计"

class b_al_combinedFleet:
	extends Buff
	var buffName = "联合舰队-负面"
	var dispel = 2
	func _init():
		attInit()
		id = "b_al_combinedFleet"
		isNegetive = true
		att.atkL = -0.8
		att.mgiAtkL = -0.8
		att.defL = -0.8
		att.mgiDefL = -0.8