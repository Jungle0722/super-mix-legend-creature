extends Talent

func init():
	name = "百战之师"
func _connect():
	sys.main.connect("onBattleStart",self,"run")

func run():
	for i in sys.main.btChas:
		if i.team == 1:
			i.addBuff(Bf.new())

func get_info():
	return "击杀敌方单位获得2点经验\n[color=#DC143C]此天赋不需要升级，所有MOD通用"

class Bf extends Buff:
	func _init():
		attInit()
	func _connect():
		masCha.connect("onKillChara",self,"run")
	func run(atkInfo):
		sys.main.player.plusEmp(2)