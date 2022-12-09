extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]糖衣炮弹"
	price = 300
	att.atk = 150
	att.mgiAtk = 150
	att.cd = 0.2
	att.spd = 0.2
	att.penL = 0.2
	att.mgiPenL = 0.2
	info = "战斗开始时，使位于自己同行对称位置的敌人<眩晕>15秒\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可被科研装备吞噬"
	
func _connect():
	._connect()
	sys.main.connect("onBattleStart",self,"run2")

func run2():
	if not utils.inBattle(masCha):return
	var cell = masCha.cell
	var cha = sys.main.matCha(Vector2(9 - cell.x, cell.y))
	if cha != null && cha.team != masCha.team:
		cha.addBuff(utils.buffs.b_xuanYun.new(15))



