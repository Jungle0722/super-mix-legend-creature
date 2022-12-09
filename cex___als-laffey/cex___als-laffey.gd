extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」拉菲"   #角色的名称
	attCoe.atkRan = 5#攻击距离
	attCoe.maxHp = 3#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 0     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 0  #魔法攻击（每点代表13.7）
	attCoe.def = 3     #物理防御（每点代表15）
	attCoe.mgiDef = 3#魔法防御（每点代表16.6）
	atkEff = "atk_dao" #攻击时的特效
	lv = 3             #等级的设置
	evos = ["cex___als-laffey2"]
	canCopy = false
	type = "dd"
	addSkill("每{cd}秒发射一枚鱼雷对目标及周围(十字范围)的敌人造成[双攻*2]的魔法伤害", "磁性鱼雷", "sk_laffey1", 5)
	addSkill("基础双攻为0，战斗开始时，分别获得敌方法强/物攻最高者等额的法强/物攻(上限2000)", "学习模式")
	addSkill("本回合阵亡2个非召唤友军时启动：冷却速度+20%，击杀敌人后立即向血量最低的2名敌人发射磁性鱼雷", "歼灭模式")
	setGunAndArmor("小型","轻型")
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("白鹰")
var p3 = 1
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="sk_laffey1" and aiCha != null:
		sk_laffey1()

#磁性鱼雷
func sk_laffey1(cha = aiCha):
	createFlyEff(sprcPos, cha, "sk_feiDang")
	for i in getCellChas(cha.cell,p3,1):
		azurHurtChara(i, (att.mgiAtk+att.atk)*2, Chara.HurtType.MGI, Chara.AtkType.SKILL, "磁性鱼雷")

func _onBattleStart():
	._onBattleStart()
	var enemy = getAllChas(1)
	enemy.sort_custom(self,"sortByAtkDesc")
	var c1 = utils.getFirstFromChas(enemy)

	enemy.sort_custom(self,"sortByMgiAtkDesc")
	var c2 = utils.getFirstFromChas(enemy)

	addBuff(b_laffey.new(min(2000, c1.att.atk), min(2000, c2.att.mgiAtk)))

class b_laffey:
	extends Buff
	var buffName = "学习模式"
	var dispel = 2
	func _init(atk = 1, mgiAtk = 1):
		attInit()
		id = "b_laffey"	
		att.atk = atk
		att.mgiAtk = mgiAtk

class b_laffey2:
	extends Buff
	var buffName = "歼灭模式"
	var dispel = 2
	var flag = true
	func _init():
		attInit()
		id = "b_laffey2"	
		att.cd = 0.5
	func _connect():
		._connect()
		masCha.connect("onKillChara", self, "run")
	func _upS():
		flag = true
	func run(atkInfo):
		if not flag:return
		flag = false
		var chas = masCha.getAllChas(1)
		chas.sort_custom(masCha, "sortByHp")
		for i in range(2):
			if i >= chas.size():break
			masCha.sk_laffey1(chas[i])

var flag = 0
var warGod = false
func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha):return
	if cha.isSumm or cha.team != team:return
	flag += 1
	if flag == 2:
		addBuff(b_laffey2.new())
		utils.createSkillTextEff("歼灭模式", position)
		if warGod:
			buffUtil.addShengDun(self, 5)
			tujin()

func tujin():
	var chas = getAllChas(1)
	chas.sort_custom(self, "sortByMaxHp")
	var vs = [Vector2(0,0),Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1),Vector2(1,1),Vector2(-1,1),Vector2(-1,-1),Vector2(1,-1)]
	for cha in chas:
		if not unlock:
			hurtChara(cha, att.mgiAtk, Chara.HurtType.MGI, Chara.AtkType.SKILL)
			return
		if cha.isDeath || cha.isSumm:continue
		var mv = Vector2(cha.cell.x ,cha.cell.y)
		for i in vs:
			var v = mv+i
			if matCha(v) == null && sys.main.isMatin(v) and setCell(v):
				var pos = sys.main.map.map_to_world(cell)
				ying(pos)
				position = pos
				aiCha = cha
				azurHurtChara(cha, cha.att.maxHp*3, Chara.HurtType.REAL, Chara.AtkType.EFF, "所罗门战神")
				addBuff(buffUtil.b_vague.new(5))
				return

func _onBattleEnd():
	._onBattleEnd()
	flag = 0

