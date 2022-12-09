extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]塑钢装甲"
	info = "使自己身后的一行(横行)的友军，获得25%减伤\n使自身受到来自正前方的敌人伤害减少50%\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效无法被科研装备吞噬[/color]"
	price = 300
	att.maxHp = 500
	att.def = 100
	att.mgiDef = 100
	
func _connect():
	._connect()
	masCha.connect("onHurt",self,"onHurt")

func onHurt(atkInfo):
	var cha = atkInfo.atkCha
	if cha.team == masCha.team:return
	if cha.cell.y == masCha.cell.y:
		atkInfo.hurtVal *= 0.5

func _upS():
	if masCha == null || not utils.inBattle(masCha):return		
	var index = masCha.cell.x
	while index > 0:
		index -= 1
		var cha = sys.main.matCha(Vector2(index, masCha.cell.y))
		if cha != null && cha.team == masCha.team and cha.hasBuff("b_al_suSteel") == null:
			cha.addBuff(b_al_suSteel.new(3))

class b_al_suSteel:
	extends Buff
	var buffName = "塑钢装甲"
	func _init(lv = 1):
		attInit()
		id = "b_al_suSteel"
		life = lv
	func _connect():
		masCha.connect("onHurt", self, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 && not atkInfo.isMiss:
			atkInfo.hurtVal *= 0.75