extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[稀有]炸药包"
	info = "装备者开局会向敌方双攻最高者发起冲锋，若战死或成功冲锋后10秒，将会引爆炸药包，使自己立即去世，对周围2格的所有敌人造成[目标血上限*25%]的神圣伤害，并使其<瘫痪>4秒\n召唤物装备效果减半"
	price = 300

func _connect():
	sys.main.connect("onBattleStart",self,"start")
	masCha.connect("onDeath", self, "onDeath")

var count = 0
var enable = true
func start():
	enable = true
	count = 0
	if not utils.inBattle(masCha):return
	yield(masCha.reTimer(0.45),"timeout")
	var chas = masCha.getAllChas(1)
	chas.sort_custom(self,"sort")
	for i in chas:
		if i.isDeath or i.isSumm:continue
		utils.jump(i, masCha)
		masCha.aiCha = i
		break

func sort(a, b):
	return a.att.atk + a.att.mgiAtk > b.att.atk + b.att.mgiAtk

func _upS():
	if not enable or masCha == null or masCha.isDeath:return
	count += 1
	if count >= 10:
		masCha.forceHurtSelf(masCha.att.maxHp)

func onDeath(atkInfo):
	cast()

func cast():
	if not enable:return
	enable = false	
	var chas = masCha.getCellChas(masCha.cell, 2, 1)
	for i in chas:
		i.addBuff(utils.buffs.b_paralysis.new(5))
		var dmg = i.att.maxHp*0.25
		if masCha.isSumm:
			dmg *= 0.5
		if i.get("type") == "BOSS":dmg *= 0.3
		i.forceHurtSelf(dmg)
		masCha.increDmgNum(dmg, "炸药包", i)
