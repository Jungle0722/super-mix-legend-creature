extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "四神之力"
	att.maxHp = 200
	att.def = 50
	att.mgiDef = 50
	info = "<限定>本回合内，死亡后，满血复活\n[color=#DC143C]同时装备三件时可升级[/color]"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()
	
func _connect():
	utils.itemUpgrade(self)
	masCha.connect("onDeath", self, "onDeath")
	sys.main.connect("onBattleStart",self,"start")

var enable = true
func start():
	enable = true
func onDeath(atkInfo):
	if enable and masCha.isDeath:
		enable = false
		masCha.isDeath = false
		if masCha.get("type") == "BOSS":
			masCha.plusHp(masCha.att.maxHp*0.2)
		else:
			masCha.plusHp(masCha.att.maxHp)
		if upgraded:
			masCha.addBuff(buffUtil.b_wudi.new(2))

var upgraded = false
func upgrade():
	name = "[color=#FFFF00]四神之力·改"
	info = "<限定>本回合内，死亡后，满血复活，且获得2秒<无敌>"
	att.maxHp = 400 * relic.equipBonus
	att.def = 100 * relic.equipBonus
	att.mgiDef = 100 * relic.equipBonus

func rare():
	name = "[color=#FF00FF][稀有]四神之力"
	att.maxHp = 300
	att.def = 70
	att.mgiDef = 70
