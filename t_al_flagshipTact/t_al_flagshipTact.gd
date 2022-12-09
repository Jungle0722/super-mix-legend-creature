extends Talent

var buffUtil = globalData.infoDs["g_azurlineBuffs"]
func init():
	name = "旗舰战术"
func _connect():
	sys.main.connect("onBattleStart",self,"run4")

func run4():
	for i in sys.main.btChas:
		if i.team == 1:
			for j in i.items:
				if j.get("itemTag") == "flag":
					i.addBuff(b_flagShip.new())

func get_info():
	return "战斗开始时，我方旗舰获得40%全属性加成(装备各种战旗的角色为旗舰)\n[color=#DC143C]此天赋不需要升级"

class b_flagShip:
	extends Buff
	var buffName = "旗舰战术"
	var dispel = 2
	func _init():
		attInit()
		id = "b_flagShip"
		att.atkL = 0.4
		att.mgiAtkL = 0.4
		att.defL = 0.4
		att.mgiDefL = 0.4
		att.cd = 0.4
		att.spd = 0.4
		att.suck = 0.4
		att.mgiSuck = 0.4
		att.reHp = 0.4
		att.cri = 0.4
		att.criR = 0.4
		att.dod = 0.4
		att.penL = 0.4
		att.mgiPenL = 0.4