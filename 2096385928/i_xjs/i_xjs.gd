extends Item

func init():
	name = "血精石"
	type = config.EQUITYPE_EQUI
	attInit()
	att.maxHp = 500
	info = "当前能量：0"
	info += "\n每隔5秒穿戴者回复[0.5%*能量点数]的最大生命值\n"
	info += "每杀死一个单位获得1点能量，最多储存35点\n穿戴者死亡后损失所有能量"

var Point = 0
var Time = 0
var Formation = "当前能量：{0}\n每隔5秒穿戴者回复[0.5%*能量点数]的最大生命值\n每杀死一个单位获得1点能量，最多储存35点\n穿戴者死亡后损失所有能量"

func _connect():
	masCha.connect("onDeath",self,"LostEnergy")
	masCha.connect("onKillChara",self,"Killed")

func _upS():
	if Time < 5 :
		Time += 1
	
	if Time == 5 :
		masCha.plusHp((0.005*Point)*masCha.att.maxHp,true)
		Time = 0

func Killed(atkInfo:AtkInfo):
	if Point < 35:
		Point += 1
		info = Formation.format({"0":Point})

func LostEnergy(atkInfo:AtkInfo):
	Point = 0
	info = Formation.format({"0":Point})