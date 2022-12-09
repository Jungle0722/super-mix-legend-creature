extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "珍珠之泪"
	att.maxHp = sys.rndRan(300, 500)
	info = "当佩戴者死亡时，给全体敌人附加10层<霜冻>[流血]\n[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()
func _connect():
	masCha.connect("onDeath",self,"run")
	utils.itemUpgrade(self)

func run(atkInfo):
	deathWord()

var upgraded = false
func upgrade():
	name = "[color=#FFFF00]珍珠之泪·改"
	info = "当佩戴者死亡时，给全体敌人附加10层<霜冻>[流血][虚弱]<烧蚀>"
	att.maxHp = 800
func rare():
	name = "[color=#FF00FF][稀有]珍珠之泪"
	info = "当佩戴者死亡时，给全体敌人附加10层<霜冻>[流血]\n[color=#DC143C]同时装备三件时可升级[/color]"
	att.maxHp = 600

func deathWord():
	var chas = masCha.getAllChas(1)
	for i in chas:
		if upgraded:
			i.addBuff(utils.buffs.b_freeze.new(10))
			i.addBuff(utils.buffs.b_liuXue_r.new(10))
			i.addBuff(utils.buffs.b_weak.new(10))
			i.addBuff(utils.buffs.b_shaoShi.new(10))
		else:
			i.addBuff(utils.buffs.b_freeze.new(10))
			i.addBuff(utils.buffs.b_liuXue_r.new(10))