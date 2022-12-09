extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]保护伞"
	info = "战斗开始时，赋予周围一格(十字范围)的友军<庇护>(完全替对方承受非特效伤害，对南达科他、雪风无效)\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效无法被科研装备吞噬[/color]"
	price = 300
	att.maxHp = 800
	att.maxHpL = 0.25
	
func _connect():
	._connect()
	sys.main.connect("onBattleStart",self,"runStart")

func runStart():
	masCha.addBuff(b_umbrella2.new())
	for i in masCha.getCellChas(masCha.cell,1,2):
		if i.hasBuff("b_umbrella") == null and i != masCha and i.hasBuff("b_umbrella2") == null:
			i.addBuff(b_umbrella.new(masCha))


class b_umbrella2:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_umbrella2"

class b_umbrella:
	extends Buff
	var buffName = "保护伞"
	var cha = null
	var exclude = ["zqzd", "snowWind"]
	var dispel = 2
	func _init(cast = null):
		attInit()
		id = "b_umbrella"
		cha = cast
	func _connect():
		masCha.connect("onHurt",self,"_onHurt")
	func _onHurt(atkInfo:AtkInfo):
		for i in masCha.skills:
			if exclude.has(i.id):
				return
		if atkInfo.hurtVal > 0 && not atkInfo.isMiss && atkInfo.atkType != Chara.AtkType.EFF && not cha.isDeath:
			atkInfo.atkCha.hurtChara(cha, atkInfo.atkVal, atkInfo.hurtType, atkInfo.atkType)
			atkInfo.hurtVal = 0
