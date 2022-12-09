extends Item
	
func init():
	name = "迈达斯之手"
	type = config.EQUITYPE_EQUI
	attInit()
	att.spd = 0.2
	info = "穿戴者杀死敌方单位后获得20金币\n单场战斗仅生效一次\n"
	info += "场上有单位死亡后会炼化，获得持续2秒的爆发性攻击速度加成"

func _connect():
	sys.main.connect("onCharaDel",self,"Died")
	sys.main.connect("onBattleStart",self,"StartBattle")

var isDone = false

func StartBattle():
	isDone = false

func Died(cha):
	if isDone == false:
		sys.main.player.plusGold(20)
		isDone = true
		masCha.addBuff(Dt_DiedOnesSpeedAdd.new())

class Dt_DiedOnesSpeedAdd:
	extends Buff
	func _init():
		attInit()
		effId = "p_jiSu"
		life = 2
		isNegetive=false
		id = "Dt_DiedOnesSpeedAdd"
		att.spd = 0.5