extends Item

func init():
	name = "影之灵龛"
	type = config.EQUITYPE_EQUI
	attInit()
	att.maxHp = 300
	att.def = 30
	att.mgiDef = 30
	info = "当前灵魂：0个\n场上有单位死亡时收集1个灵魂,最多收集60个\n每5秒为所有友军回复[3*能量]生命值\n每5秒对所有敌人造成[6*能量]魔法伤害\n受到攻击会导致丢失灵魂"

func _connect():
	sys.main.connect("onCharaDel",self,"Death")
	masCha.connect("onHurt",self,"UserBeenAttacked")
	sys.main.connect("onBattleStart",self,"StartBattle")

var Formation = "当前灵魂：{0}个\n场上有单位死亡时收集1个灵魂,最多收集60个\n每5秒为所有友军回复{1}生命值\n每5秒对所有敌人造成{2}魔法伤害\n受到攻击会导致丢失1个灵魂"
var Point = 0
var Revive = 0
var Attack = 0
var Time = 0
func StartBattle():
	Time = 0

func Death(cha):
	if Point < 60:
		Point += 1
		Revive = Point * 3
		Attack = Point * 6
		info = Formation.format({"0":Point, "1":Revive, "2":Attack})

func UserBeenAttacked(atkInfo:AtkInfo):
	if Point > 0:
		Point -= 1
		info = Formation.format({"0":Point, "1":Revive, "2":Attack})

func _upS():
	Time += 1
	if Point > 0 && Time == 5:
		var teamChas = masCha.getAllChas(2)
		var enemyChas = masCha.getAllChas(1)
		for i in teamChas:
			i.plusHp(Revive,true)
		for i in enemyChas:
			masCha.hurtChara(i,Attack,Chara.HurtType.MGI,Chara.AtkType.EFF)
		Time = 0