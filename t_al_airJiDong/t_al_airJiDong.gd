extends Talent

var buffUtil = globalData.infoDs["g_azurlineBuffs"]
func init():
	name = "空战机动"
func _connect():
	sys.main.connect("onCharaNewChara", self, "onCharaNewChara")

func onCharaNewChara(cha):
	if cha.team == 1:
		if cha.get("prefer") == "tbf":
			cha.addBuff(b_airJD2.new())	
		elif cha.get("prefer") == "cas":
			cha.addBuff(b_airJD1.new())
		elif cha.get("prefer") == "fighter":
			cha.addBuff(b_airJD3.new())

func get_info():
	return "我方所有舰载机获得生存强化：\n轰炸机获得100%吸血\n鱼雷机每6秒获得2层<圣盾>\n战斗机获得20%闪避、双防\n[color=#DC143C]此天赋不需要升级"

#轰炸机
class b_airJD1 extends Buff:
	var dispel = 2
	func _init():
		attInit()
		id = "b_airJD1"
		att.suck = 1

#鱼雷机
class b_airJD2 extends Buff:
	var dispel = 2
	func _init():
		attInit()
		id = "b_airJD2"
	var num = 3
	func _upS():
		num += 1
		if num >= 6:
			masCha.buffUtil.addShengDun(masCha, 2)
			num = 0

#战斗机
class b_airJD3 extends Buff:
	var dispel = 2
	func _init():
		attInit()
		id = "b_airJD3"
		att.dod = 0.2
		att.defL = 0.2
		att.mgiDefL = 0.2