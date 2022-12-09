extends "../cex___almiu-cleveland/cex___almiu-cleveland.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」克利夫兰·μ兵装"   #角色的名称
	attCoe.atkRan = 3  #攻击距离
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	attCoe.def += 2  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___almiu-cleveland3"]
	supportSpecEvo = 2
	skillStrs.pop_back()
	addSkill("<先手>每{cd}向距离最远的敌人投掷一个大宝贝，使其[眩晕]2秒，造成[攻击*4]({damage})的伤害\n						在效果结束时，若目标身边存在其他队友，则随机弹向其队友，最多弹射4次", "所罗门传说", "slmcs", 8)
	
	autoGetSkill()
	addSkillTxt(jbText)
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="slmcs":
		slmcs()

func slmcs():
	utils.createSkillTextEff("所罗门传说", position)
	var chas=getAllChas(1)
	chas.sort_custom(self,"sortByDistanceDesc")
	createFlyEff(sprcPos, chas[0], "sk_4_1_2")
	chas[0].addBuff(b_tantanle2.new(1, 4, self))
	doSlmDmg(chas[0])

func doSlmDmg(cha):
	azurHurtChara(cha, att.atk*4*(1+miuNum*0.5), Chara.HurtType.PHY, Chara.AtkType.SKILL, "所罗门传说")

func _onBattleStart():
	._onBattleStart()
	slmcs()
	
class b_tantanle2:
	extends Buff
	var buffName = "所罗门传说"
	var num = 1
	var maxNum = 4
	var utils = globalData.infoDs["g_azurlineUtils"]
	var cha
	func _init(num = 1, maxNum = 4, cha = null):
		attInit()
		id = "b_tantanle2"
		life = 2
		self.num = num
		self.maxNum = maxNum
		isNegetive=true
		self.cha = cha
	func _connect():
		._connect()
		masCha.aiOn = false
		eff2 = sys.newEff("animEff", masCha.position)
		eff2.setImgs(utils.path + "/eff/yunXuan", 5, true)
		eff2.scale *= 1
		eff2.normalSpr.position=Vector2(0, -70)
	var eff2
	func _process(delta):
		if masCha != null && is_instance_valid(eff2):
			eff2.position = masCha.position
	func _del():
		._del()
		if is_instance_valid(eff2):
			eff2.queue_free()
		masCha.aiOn = true
		if num >= maxNum:
			return
		var chas = masCha.getCellChas(masCha.cell,2,2)
		if chas == null || chas.size() == 0:
			return
		chas.shuffle()
		var t
		for i in chas:
			if i != masCha && not i.isDeath && not i.hasBuff("b_tantanle2"):
				t = i
		if t != null:
			var d:Eff = masCha.newEff("sk_4_1_2",masCha.sprcPos)
			d._initFlyCha(t)
			yield(d,"onReach")
			t.addBuff(b_tantanle2.new(num + 1, 4, cha))
			cha.doSlmDmg(t)