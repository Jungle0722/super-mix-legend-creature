extends "../azurline_base_item/azurline_base_item.gd"

func init():
	.init()
	name = "洞察烟斗"
	att.mgiDef = 60
	att.def = 30
	att.maxHp = 100
	info = "战斗开始时给所有友军套上能抵挡250点魔法伤害的护盾"

func _connect():
	sys.main.connect("onBattleStart",self,"StartBattle")

func StartBattle():
	for i in getAllChas(2):
		i.changeShield(250)