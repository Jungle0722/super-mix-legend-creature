extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[稀有]碧蓝战旗"
	info = "<唯一>战斗开始时，所有北方联合/自由鸢尾/其他阵营的舰娘：\n[color=#DC143C]攻速+15%\n双攻+10%\n冷却速度+10%[/color]\n解锁阵营成就后可升级\n[color=#C0C0C0]携带军旗的角色，成为[旗舰]，当旗舰阵亡时，损失30点玩家生命值，对应阵营的友军移除加成并全部<虚弱>5秒\n三个任意阵营的军旗可以合成对所有角色生效的特殊旗子[/color]"
	price = 200
	base = globalData.infoDs["g_azurlineBase"]
	if not base.getSetting("achiCamp", []).empty():
		achi()
var itemTag = "flag"
var level = 1
var text2 = "<唯一>战斗开始时，所有北方联合/自由鸢尾/其他阵营的舰娘：\n[color=#DC143C]攻速+30%\n双攻+20%\n冷却速度+20%[/color]\n[color=#C0C0C0]同时再装备2个稀有品质的同阵营军旗可升级，携带军旗的角色，成为[旗舰]"
var text3 = "<唯一>战斗开始时，所有北方联合/自由鸢尾/其他阵营的舰娘：\n[color=#DC143C]攻速+30%\n双攻+20%\n冷却速度+20%[/color]\n场上每有一名北方联合/自由鸢尾/其他阵营的角色，提高15%加成\n[color=#C0C0C0]携带军旗的角色，成为[旗舰]"
func achi():
	info = "<唯一>战斗开始时，所有北方联合/自由鸢尾/其他阵营的舰娘：\n[color=#DC143C]攻速+15%\n双攻+10%\n冷却速度+10%[/color]\n[color=#C0C0C0]同时再装备2个稀有品质的同阵营军旗可升级，携带军旗的角色，成为[旗舰]\n三个任意阵营的军旗可以合成对所有角色生效的特殊旗子"
	achi = true

func levelUp():
	if level == 3:return
	level += 1
	upgrade()

func upgrade():
	match level:
		2:
			name = "[color=#FF00FF][史诗]碧蓝战旗"
			info = text2
		3:
			name = "[color=#FFFF00][传说]碧蓝战旗"
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
		var bf = i.hasBuff("b_flag_x")
		if bf != null:
			bf.isDel = true
			i.addBuff(utils.buffs.b_weak.new(5))

func start():
	if masCha == null or not utils.inBattle(masCha):return
	flag = true
	var chas = []
	for i in masCha.getAllChas(2):
		if i.get("camp") == "北方联合" or i.get("camp") == "自由鸢尾" or i.get("camp") == "其他":
			chas.append(i)
	for i in chas:
		if i.hasBuff("b_flag_x") != null or i.hasBuff("b_flag_all") != null:continue
		i.addBuff(b_flag_x.new(level, 1 + 0.15 * chas.size()))


class b_flag_x:
	extends Buff
	var buffName = "碧蓝战旗"
	var dispel = 2
	func _init(level = 1, num = 1):
		attInit()
		id = "b_flag_x"
		if level == 1:
			att.atkL = 0.1
			att.mgiAtkL = 0.1
			att.cd = 0.1
			att.spd = 0.15
		elif level == 2:
			att.atkL = 0.2
			att.mgiAtkL = 0.2
			att.cd = 0.2
			att.spd = 0.3
		else:
			att.atkL = 0.2 * num
			att.mgiAtkL = 0.2 * num
			att.cd = 0.2 * num
			att.spd = 0.3 * num
	func _connect():
		masCha.plusHp(2000)