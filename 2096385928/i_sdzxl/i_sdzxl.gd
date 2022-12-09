extends Item

func init():
	name = "撒旦之邪力"
	type = config.EQUITYPE_EQUI
	attInit()
	att.suck = 0.3
	att.atk = 30
	info = "进入战斗10秒后，物理吸血提升至50%"


func _connect():
	sys.main.connect("onBattleEnd",self,"EndBattle")

var time_sdzkr = 0

func EndBattle():
	time_sdzkr = 0
	masCha.attAdd.suck = 0

func _upS():
	time_sdzkr += 1
	if time_sdzkr == 9:
		var eff:Eff = masCha.newEff("sk_shiBao") #借用了尸爆的特效
		eff.position = masCha.position
		yield(sys.main.get_tree().create_timer(0.1),"timeout")
		masCha.addBuff(Dt_SuckDL.new())

class Dt_SuckDL extends Buff:
	func _init(lv=1):
		attInit()
		life = 2
		isNegetive=true
		id = "Dt_SuckDL"
		att.suck = 0.3
	func _upS():
		life += 1