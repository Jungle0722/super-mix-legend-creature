extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[稀有]白鹰军旗"
	info = "<唯一>战斗开始时，我方场上每有一名白鹰阵营舰娘，则所有白鹰阵营的舰娘：\n[color=#DC143C]双攻+2%\n冷却+2%\n普攻附带1层<烧蚀>效果[/color]\n解锁阵营成就后可升级\n[color=#C0C0C0]携带军旗的角色，成为[旗舰]，当旗舰阵亡时，损失30点玩家生命值，对应阵营的友军移除加成并全部<虚弱>5秒\n三个任意阵营的军旗可以合成对所有角色生效的特殊旗子[/color]"
	price = 200
	base = globalData.infoDs["g_azurlineBase"]
	if not base.getSetting("achiCamp", []).empty():
		achi()
var itemTag = "flag"
var level = 1
var text2 = "<唯一>战斗开始时，我方场上每有一名白鹰阵营舰娘，则所有白鹰阵营的舰娘：\n[color=#DC143C]双攻+3%\n冷却+3%\n普攻附带1层<烧蚀>效果[/color]\n[color=#C0C0C0]同时再装备2个稀有品质的同阵营军旗可升级，携带军旗的角色，成为[旗舰]"
var text3 = "<唯一>战斗开始时，我方场上每有一名白鹰阵营舰娘，则所有白鹰阵营的舰娘：\n[color=#DC143C]双攻+4%\n冷却+4%\n普攻附带1层<烧蚀>效果[/color]\n[color=#C0C0C0]携带军旗的角色，成为[旗舰]"
func achi():
	info = "<唯一>战斗开始时，我方场上每有一名白鹰阵营舰娘，则所有白鹰阵营的舰娘：\n[color=#DC143C]双攻+2%\n冷却+2%\n普攻附带1层<烧蚀>效果[/color]\n[color=#C0C0C0]同时再装备2个稀有品质的同阵营军旗可升级，携带军旗的角色，成为[旗舰]\n三个任意阵营的军旗可以合成对所有角色生效的特殊旗子"
	# achi = true

func levelUp():
	if level == 3:return
	level += 1
	upgrade()

func upgrade():
	match level:
		2:
			name = "[color=#FF00FF][史诗]白鹰军旗"
			info = text2
		3:
			name = "[color=#FFFF00][传说]白鹰军旗"
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
		var bf = i.hasBuff("b_flag_by")
		if bf != null:
			bf.isDel = true
			i.addBuff(utils.buffs.b_weak.new(5))

func start():
	if masCha == null or not utils.inBattle(masCha):return
	flag = true
	var chas = []
	for i in masCha.getAllChas(2):
		if i.get("camp") == "白鹰":
			chas.append(i)
	for i in chas:
		if i.hasBuff("b_flag_by") != null or i.hasBuff("b_flag_all") != null:continue
		i.addBuff(b_flag_by.new(level, chas.size()))

class b_flag_by:
	extends Buff
	var buffName = "白鹰军旗"
	var dispel = 2
	var utils = globalData.infoDs["g_azurlineUtils"]
	var level = 1
	var num = 1
	func _init(level = 1, num = 1):
		attInit()
		id = "b_flag_by"
		self.level = level
		self.num = num
		if level == 1:
			att.atkL = 0.02*num
			att.mgiAtkL = 0.02*num
			att.cd = 0.02*num
		elif level == 2:
			att.atkL = 0.03*num
			att.mgiAtkL = 0.03*num
			att.cd = 0.03*num
		else:
			att.atkL = 0.04*num
			att.mgiAtkL = 0.04*num
			att.cd = 0.04*num
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL:
			atkInfo.hitCha.addBuff(utils.buffs.b_shaoShi.new(1))

	