extends Item

func init():
	name = "梅肯斯姆"
	type = config.EQUITYPE_EQUI
	attInit()
	att.maxHp = 150
	att.def = 10
	att.mgiDef = 10
	att.cd = 0.2
	info = "释放技能时回复所有友军20%魔法强度的生命值，需要2秒充能时间"

var t = 0
func StartBattle():
	t = 0

func _upS():
	t += 1

func _connect():
	masCha.connect("onCastCdSkill",self,"Cast")
	sys.main.connect("onBattleStart",self,"StartBattle")

func Cast(id):
	if t >= 2:
		var teamChas = masCha.getAllChas(2)
		for i in teamChas:
			i.plusHp(masCha.att.mgiAtk * 0.2,true)
		t = 0