extends Item

func init():
	name = "死灵书"
	type = config.EQUITYPE_EQUI
	attInit()
	att.maxHp = 350
	info = "召唤一个四臂将军和骷髅法师为你作战(仅玩家有效)\n四臂将军死亡时对周围敌军造成600点真实伤害\n骷髅法师释放技能附带穿戴者10%最大生命值的真实伤害\n只能存在一对死灵"

var Noita = null
var DeathNum = 0

func _connect():
	sys.main.connect("onBattleStart",self,"StartBattle")
	masCha.connect("onNewChara",self,"CallChara")

func StartBattle():
	Noita = null
	DeathNum = 0
	var isSummoned = false
	var CheckChas = masCha.getAllChas(2)
	for i in CheckChas:
		if (i.id == "c6_1_1" && i.isSumm == true) || (i.id == "c6_1_2" && i.isSumm == true):
			isSummoned = true
			break
	if isSummoned == false && masCha.team == 1:	
		masCha.newChara("c6_1_1",masCha.cell)
		yield(sys.main.get_tree().create_timer(0.45),"timeout")
		masCha.newChara("c6_1_2",masCha.cell)

func CallChara(cha):
	if cha.id == "c6_1_1":
		cha.connect("onDeath",self,"WarriorDeath")
		cha.addSkillTxt("死亡后引爆自身，对周围敌军造成600点真实伤害")
		cha.chaName = "死灵书 · 四臂将军"
	if cha.id == "c6_1_2":
		cha.connect("onAtkChara",self,"NoitaHurt")
		var Txt = "技能命中时附带 {s} 最大生命值10%的真实伤害"
		cha.addSkillTxt(Txt.format({"s":str(masCha.chaName)}))
		cha.chaName = "死灵书 · 骷髅法师"
		Noita = cha

func WarriorDeath(atkInfo:AtkInfo):
	print("d")
	if DeathNum == 1:
		print(1)
		var enemyChas = masCha.getCellChas(atkInfo.hitCha.cell,1)
		for i in enemyChas:
			print(i.id)
			masCha.hurtChara(i,600,Chara.HurtType.REAL,Chara.AtkType.EFF)
			DeathNum += 1
	elif DeathNum == 0:
		print(0)
		DeathNum += 1

func NoitaHurt(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.SKILL:
		Noita.hurtChara(Noita.aiCha,masCha.att.maxHp * 0.1,Chara.HurtType.REAL,Chara.AtkType.EFF)
		print(masCha.att.maxHp * 0.1)