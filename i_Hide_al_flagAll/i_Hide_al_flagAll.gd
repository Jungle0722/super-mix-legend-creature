extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[稀有]纳尔逊的旗语"
	info = "<唯一>战斗开始时，我方所有舰娘：\n[color=#DC143C]攻速+15%\n双攻+15%\n冷却速度+15%\n血上限+15%[/color]\n[color=#C0C0C0]携带军旗的角色，成为[旗舰]，和其他所有类型的军旗冲突[/color]"
	price = 200
	
var flag = true
func _connect():
	sys.main.connect("onBattleStart",self,"start")

func start():
	if masCha == null or not utils.inBattle(masCha):return
	flag = true
	for i in masCha.getAllChas(2):
		if i.hasBuff("b_flag_all") != null or i.hasBuff("b_flag_by") != null or i.hasBuff("b_flag_cy") != null or i.hasBuff("b_flag_hj") != null or i.hasBuff("b_flag_z") != null or i.hasBuff("b_flag_x") != null:continue
		i.addBuff(b_flag_all.new())

class b_flag_all:
	extends Buff
	var buffName = "纳尔逊的旗语"
	var dispel = 2
	func _init():
		attInit()
		id = "b_flag_all"
		att.atkL = 0.15
		att.mgiAtkL = 0.15
		att.maxHpL = 0.15
		att.cd = 0.15
		att.spd = 0.15
	func _connect():
		masCha.plusHp(2000)