extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[稀有]重樱军旗"
	info = "<唯一>战斗开始时，所有重樱阵营的舰娘：\n[color=#DC143C]双攻+80\n双防+80\n冷却速度+15%[/color]\n解锁阵营成就后可升级\n[color=#C0C0C0]携带军旗的角色，成为[旗舰]，当旗舰阵亡时，损失30点玩家生命值，对应阵营的友军移除加成并全部<虚弱>5秒\n三个任意阵营的军旗可以合成对所有角色生效的特殊旗子[/color]"
	price = 200
	base = globalData.infoDs["g_azurlineBase"]
	if not base.getSetting("achiCamp", []).empty():
		achi()
var itemTag = "flag"
var level = 1
var text2 = "<唯一>战斗开始时，所有重樱阵营的舰娘：\n[color=#DC143C]双攻+240\n双防+240\n冷却速度+30%[/color]\n[color=#C0C0C0]同时再装备2个稀有品质的同阵营军旗可升级，携带军旗的角色，成为[旗舰]"
var text3 = "<唯一>战斗开始时，所有重樱阵营的舰娘：\n[color=#DC143C]双攻+240\n双防+240\n冷却速度+30%[/color]\n场上每有一名重樱阵营的角色，提高10%加成\n[color=#C0C0C0]携带军旗的角色，成为[旗舰]"
func achi():
	info = "<唯一>战斗开始时，所有重樱阵营的舰娘：\n[color=#DC143C]双攻+80\n双防+80\n冷却速度+15%[/color]\n[color=#C0C0C0]同时再装备2个稀有品质的同阵营军旗可升级，携带军旗的角色，成为[旗舰]\n三个任意阵营的军旗可以合成对所有角色生效的特殊旗子"
	achi = true

func levelUp():
	if level == 3:return
	level += 1
	upgrade()

func upgrade():
	match level:
		2:
			name = "[color=#FF00FF][史诗]重樱军旗"
			info = text2
		3:
			name = "[color=#FFFF00][传说]重樱军旗"
			info = text3

var flag = true
func _connect():
	sys.main.connect("onBattleStart",self,"start")
	upgradeCheck()
	if not masCha.isSumm:
		masCha.connect("onDeath",self,"_onDeath")

func _onDeath(atkInfo):
	if achi:return
	if masCha.team == 1 and flag:
		sys.main.player.plusHp(-30)
		flag = false
	for i in masCha.getAllChas(2):
		var bf = i.hasBuff("b_flag_cy")
		if bf != null:
			bf.isDel = true
			i.addBuff(utils.buffs.b_weak.new(5))

func start():
	if masCha == null or not utils.inBattle(masCha):return
	flag = true
	var chas = []
	for i in masCha.getAllChas(2):
		if i.get("camp") == "重樱":
			chas.append(i)
	for i in chas:
		if i.hasBuff("b_flag_cy") != null or i.hasBuff("b_flag_all") != null:continue
		i.addBuff(b_flag_cy.new(level, 1 + 0.1 * chas.size()))

class b_flag_cy:
	extends Buff
	var buffName = "重樱军旗"
	var dispel = 2
	func _init(level = 1, num = 1):
		attInit()
		id = "b_flag_cy"
		if level == 1:
			att.atk = 80
			att.mgiAtk = 80
			att.def = 80
			att.mgiDef = 80
			att.cd = 0.15
		elif level == 2:
			att.atk = 240
			att.mgiAtk = 240
			att.def = 240
			att.mgiDef = 240
			att.cd = 0.30
		else:
			att.atk = 240 * num
			att.mgiAtk = 240 * num
			att.def = 240 * num
			att.mgiDef = 240 * num
			att.cd = 0.30 * num
	func _connect():
		masCha.plusHp(2000)