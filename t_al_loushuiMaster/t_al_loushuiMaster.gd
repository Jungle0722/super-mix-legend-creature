extends Talent

var buffUtil = globalData.infoDs["g_azurlineBuffs"]
func init():
	name = "漏水专精"
func _connect():
	sys.main.connect("onCharaAddBuff",self,"run")

func run(buff:Buff):
	if buff.id == "b_louShui":
		if buff.masCha.team == 2:
			buff.pw = 1.2
			buff.dispel = 2

func get_info():
	return "漏水效果伤害提高20%且不可驱散\n[color=#DC143C]此天赋不需要升级"

