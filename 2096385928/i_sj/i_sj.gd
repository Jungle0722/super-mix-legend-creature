extends Item
func init():
	name = "圣剑"
	type = config.EQUITYPE_EQUI
	attInit()
	att.atk = 100
	att.cri = 0.3
	info = "战斗开始时，获得25层狂怒\n穿戴者死亡后圣剑将破损，不再提供狂怒效果"
	
var Equit_GodBlade_Time = 0
var Formation = "战斗开始时，获得25层狂怒\n穿戴者死亡后圣剑将破损，不再提供狂怒效果"

var hasDied = false

func _onBattleStart():
	if masCha.team == 2:
		hasDied = true
	Equit_GodBlade_Time=0
	if hasDied == true:
		name = "破损的圣剑"
		info = ""

func _connect():
	masCha.connect("onDeath",self,"_onDeath")
	sys.main.connect("onBattleStart",self,"_onBattleStart")

func _upS():
	Equit_GodBlade_Time += 1
	if Equit_GodBlade_Time == 1 && hasDied == false:
		masCha.addBuff(b_kuangNu.new(25))

func _onDeath(atkInfo:AtkInfo):
	hasDied = true
	name = "破损的圣剑"
	info = ""