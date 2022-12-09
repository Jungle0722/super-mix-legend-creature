extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "火控雷达"
	att.cri = sys.rndRan(15, 35)/100 as float
	att.criR = sys.rndRan(10, 30)/100 as float
	att.atk = sys.rndRan(20, 60)
	info = "自身及周围1格友军攻击无视闪避\n[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()
	
#周围一格
func _connect():
	sys.main.connect("onBattleStart",self,"run")
	utils.itemUpgrade(self)

func run():
	if upgraded and masCha.team == 1:
		var chas = masCha.getAllChas(2)
		for i in chas:
			i.addBuff(utils.buffs.b_biZhong.new())
	else:
		for i in aroundCells:
			var cha = masCha.matCha(masCha.cell+i)
			if cha != null && cha.team == masCha.team:
				cha.addBuff(utils.buffs.b_biZhong.new())

var upgraded = false
func upgrade():
	name = "[color=#FFFF00]火控雷达·改"
	info = "全体友军攻击无视闪避"
	att.cri = 0.4 * relic.equipBonus
	att.criR = 0.4 * relic.equipBonus
	att.atk = 80 * relic.equipBonus
func rare():
	name = "[color=#FF00FF][稀有]火控雷达"
	info = "自身及周围1格友军攻击无视闪避\n[color=#DC143C]同时装备三件时可升级[/color]"
	att.cri = 0.3
	att.criR = 0.3
	att.atk = 60