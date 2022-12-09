extends Talent
var buffs = globalData.infoDs["g_azurlineBuffs"]
var utils = globalData.infoDs["g_azurlineUtils"]
func init():
	name = "舰队护航"

func _connect():
	sys.main.connect("onBattleStart",self,"run")

func run():
	for i in sys.main.btChas:
		if i.team == 1 && i.cell.x <= 1:
			var type = utils.getChaType(i)
			i.addBuff(buffs.b_hurtVal.new(0.7, 0, true))

func get_info():
	return "战斗开始时，我方最后两列的单位获得30%减伤\n[color=#DC143C]此天赋不需要升级，所有MOD通用"

	