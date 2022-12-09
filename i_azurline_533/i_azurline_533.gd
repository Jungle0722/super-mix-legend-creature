extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "五联装533mm鱼雷"
	att.mgiAtk = 50
	att.cd = 0.2
	info = "造成6次技能伤害后，发射一条鱼雷，对直线上的所有敌人造成[法强*2]的特效伤害\n[color=#DC143C]同时装备三件时可升级[/color]\n基础属性数值随机浮动"
	if sys.rndPer(utils.rareItem) && sys.main != null:
		rare()
	
func _connect():
	masCha.connect("onAtkChara",self,"run")
	utils.itemUpgrade(self)
var snum = 0
func run(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.SKILL and atkInfo.hitCha.team != atkInfo.atkCha.team: 
		snum += 1
		if snum >= 6 and masCha.aiCha != null:
			snum = 0
			var eff:Eff = masCha.newEff("sk_chuanTouJian", masCha.sprcPos)
			eff._initFlyPos(masCha.position + (masCha.aiCha.position - masCha.position).normalized() * 1000,250)
			eff.connect("onInCell",self,"effInCell")

func effInCell(cell):
	var cha = masCha.matCha(cell)
	if cha == null:
		cha = masCha.matCha(cell + Vector2(0, 1))
	if cha != null && cha.team != masCha.team:
		if masCha.get("tag") == "azurline":
			masCha.azurHurtChara(cha, masCha.att.mgiAtk*p, Chara.HurtType.MGI, Chara.AtkType.EFF, "五联装533mm鱼雷")
		else:
			masCha.hurtChara(cha, masCha.att.mgiAtk*p, Chara.HurtType.MGI, Chara.AtkType.EFF)

var upgraded = false
var p = 2
func upgrade():
	name = "[color=#FFFF00]五联装533mm鱼雷·改"
	info = "造成6次技能伤害后，发射一条鱼雷，对直线上的所有敌人造成[法强*4]的特效伤害"
	att.mgiAtk = 100 * relic.equipBonus
	att.cd = 0.4 * relic.equipBonus
	p = 4

func rare():
	name = "[color=#FF00FF][稀有]五联装533mm鱼雷"
	att.mgiAtk = 75
	att.cd = 0.2
