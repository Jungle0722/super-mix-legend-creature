extends "../cazurlineC/cazurlineC.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」希佩尔·μ兵装"   #角色的名称
	attCoe.maxHp += 3   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 4
	attCoe.atkRan = 3
	lv = 3             #等级的设置
	evos = ["cex___almiu-hipper2"]
	supportSpecEvo = 2
	canCopy = false
	prefer = "ad"

	addSkill("死亡时，引爆携带的核弹,对周围2格的所有敌人造成[自身攻击*10]({damage})的物理伤害", "玉石俱焚")
	addSkill("战斗开始时，获得8层<狂怒>并向前突进3格(若失败则尝试继续向前，直到尽头)，嘲讽周围3格的敌人，\n					并获得[μ兵装舰娘人数]层<死战>", "诱敌深入")
	if id == "cex___al-hipper":
		addSkillTxt(jbText)

	autoGetSkill()
	prefer = "t"
	setGunAndArmor("中型","重型")
	setCamp("铁血")
	ename = "xipeier"

var jbText = "[color=#C0C0C0][μ羁绊]-战斗开始时，场上μ兵装舰娘数量达到2/5/8个时，分别获得：20%攻击加成/30%血量加成/兵装解放技能强化[/color]"
func _onBattleStart():
	._onBattleStart()
	addBuff(buffUtil.b_kuangNu_r.new(8))
	ydsr()

func _onHurt(atkInfo:AtkInfo):
	._onHurt(atkInfo)
	if hasBuff("b_hipper") and atkInfo.hurtVal * 1.2 >= att.hp:
		atkInfo.hurtVal = 0
var kn = 0
var enable = true
func _onDeath(atkInfo):
	._onDeath(atkInfo)
	if not enable:return
	var chas = getCellChas(cell, 2, 1)
	var dmg = getSkillEffect("玉石俱焚") * (1 + miuNum*0.2)
	for i in chas:
		azurHurtChara(i, dmg, Chara.HurtType.PHY, Chara.AtkType.SKILL, "玉石俱焚")
	enable = false
func _onBattleEnd():
	._onBattleEnd()
	enable = true
	kn = 0
func ydsr():
	yield(reTimer(0.5), "timeout")
	addBuff(b_hipper.new(min(10, miuNum), upgraded))
	var mv = Vector2(cell.x + 3 ,cell.y)
	while sys.main.isMatin(mv):
		if matCha(mv) == null and setCell(mv):
			var pos = sys.main.map.map_to_world(cell)
			ying(pos)
			position = pos
			break
		else:
			mv += Vector2(1, 0)
	var chas = getCellChas(cell, 3, 1)
	for i in chas:
		i.addBuff(buffUtil.b_taunt.new(min(10, miuNum), self))
		i.aiCha = self


class b_hipper:
	extends Buff
	var buffName = "死战"
	var r = 100
	var dispel = 2
	func _init(lv = 1, upgraded = false):
		attInit()
		id = "b_hipper"
		life = lv
		att.atkR = 0.5
	func _connect():
		._connect()
		masCha.connect("onHurt", self, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.atkType != Chara.AtkType.EFF && sys.rndPer(r) && atkInfo.atkCha.hasBuff("b_counterattack") == null and atkInfo.atkCha.team != masCha.team:
			masCha.normalAtkChara(atkInfo.atkCha)


######################μ兵装相关######################
var p4 = 10
func jiBan1():
	addBuff(buffUtil.b_atkL.new(2))

func jiBan2():
	addBuff(buffUtil.b_maxHpL.new(3))

func jiBan3():
	p4 = 8

func finalAwaken():
	p4 = 5

func resetAwaken():
	p4 = 10