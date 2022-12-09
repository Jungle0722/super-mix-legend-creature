extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[稀有]Z旗"
	info = "<唯一>战斗开始时，所有铁血阵营的舰娘：\n[color=#DC143C]血上限+300\n双防+20%\n对所受非特效伤害的来源者反弹[60%攻击伤害+30%护甲]的物理伤害[/color]\n解锁阵营成就后可升级\n[color=#C0C0C0]携带军旗的角色，成为[旗舰]，当旗舰阵亡时，损失30点玩家生命值，对应阵营的友军移除加成并全部<虚弱>5秒\n三个任意阵营的军旗可以合成对所有角色生效的特殊旗子[/color]"
	price = 200
	base = globalData.infoDs["g_azurlineBase"]
	if not base.getSetting("achiCamp", []).empty():
		achi()
var itemTag = "flag"
var level = 1
var text2 = "<唯一>战斗开始时，所有铁血阵营的舰娘：\n[color=#DC143C]血上限+900\n双防+40%\n对所受非特效伤害的来源者反弹[100%攻击伤害+50%护甲]的物理伤害[/color]\n[color=#C0C0C0]同时再装备2个稀有品质的同阵营军旗可升级，携带军旗的角色，成为[旗舰]"
var text3 = "<唯一>战斗开始时，所有铁血阵营的舰娘：\n[color=#DC143C]血上限+900\n双防+40%\n对所受非特效伤害的来源者反弹[100%攻击伤害+50%护甲]的物理伤害[/color]\n场上每有一名铁血阵营的角色，提高10%加成\n[color=#C0C0C0]携带军旗的角色，成为[旗舰]"
func achi():
	info = "<唯一>战斗开始时，所有铁血阵营的舰娘：\n[color=#DC143C]血上限+300\n双防+20%\n对所受非特效伤害的来源者反弹[60%攻击伤害+30%护甲]的物理伤害[/color]\n[color=#C0C0C0]同时再装备2个稀有品质的同阵营军旗可升级，携带军旗的角色，成为[旗舰]\n三个任意阵营的军旗可以合成对所有角色生效的特殊旗子"
	achi = true

func levelUp():
	if level == 3:return
	level += 1
	upgrade()

func upgrade():
	match level:
		2:
			name = "[color=#FF00FF][史诗]Z旗"
			info = text2
		3:
			name = "[color=#FFFF00][传说]Z旗"
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
		var bf = i.hasBuff("b_flag_z")
		if bf != null:
			bf.isDel = true
			i.addBuff(utils.buffs.b_weak.new(5))

func start():
	flag = true
	var chas = []
	for i in masCha.getAllChas(2):
		if i.get("camp") == "铁血" or i.get("camp") == "撒丁帝国":
			chas.append(i)
	for i in chas:
		if i.hasBuff("b_flag_z") != null or i.hasBuff("b_flag_all") != null:continue
		i.addBuff(b_flag_z.new(level, 1 + 0.1 * chas.size()))

class b_flag_z:
	extends Buff
	var buffName = "Z旗"
	var dispel = 2
	var reflect = 0.6
	var flag = true
	var bonus = 1
	func _init(level = 1, num = 1):
		attInit()
		id = "b_flag_z"
		if level == 1:
			att.defL = 0.2
			att.mgiDefL = 0.2
			att.maxHp = 300
			reflect = 0.6
		elif level == 2:
			att.defL = 0.4
			att.mgiDefL = 0.4
			att.maxHp = 900
			reflect = 1
		else:
			att.defL = 0.4 * num
			att.mgiDefL = 0.4 * num
			att.maxHp = 900 * num
			reflect = 1 * num
	func _upS():
		flag = true
	func plusReflect(num = 0):
		if flag:
			reflect += num
			flag = false
		
	func _connect():
		masCha.plusHp(2000)
		masCha.connect("onHurt", self, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 and atkInfo.atkType != Chara.AtkType.EFF and not atkInfo.atkCha.isDeath:
			masCha.azurHurtChara(atkInfo.atkCha, (atkInfo.atkVal + masCha.att.def * 0.5) * reflect * bonus, atkInfo.hurtType, Chara.AtkType.EFF, "反伤-Z旗")
