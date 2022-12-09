extends "../cazurlineA_2/cazurlineA_2.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「驱逐」凯旋"   #角色的名称
	attCoe.maxHp += 1
	lv = 3             #等级的设置
	evos = ["cazurlineA_2_1_1"]
	addSkill("每{cd}秒发动剑刃风暴，免疫技能伤害并对周围(九宫格范围)的所有敌人造成每秒[法强*0.8]({damage})的伤害，持续3秒", "剑刃风暴", "jrfb", 8)
	cmBuffFlag = false
	autoGetSkill()
	setCamp("自由鸢尾")
var p3 = 3
var p3_1 = 1

func _onBattleStart():
	._onBattleStart()
	var sk = getSkill("jrfb")
	sk.nowTime += 3

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="jrfb":
		jrfb()
	
func jrfb():
	addBuff(b_jrfb.new(p3, p3_1))
	awakenProcess += 1
	if awakenProcess >= 60 and not isAwaken and lv == 4:
		call("awaken")

class b_jrfb:
	extends Buff
	var buffName = "剑刃风暴"
	var num
	var rng = 1
	var dispel = 2
	func _init(lv = 1, rng = 1):
		attInit()
		self.num = num
		self.rng = rng
		life = lv
		id = "b_jrfb"
	var eff2
	func _connect():
		masCha.connect("onHurt",self,"_onHurt")
		eff2 = sys.newEff("animEff", masCha.position)
		eff2.setImgs(masCha.direc + "eff/jianRenFengBao", 6, true)
		eff2.scale *= 3
		eff2.normalSpr.position=Vector2(0, -10)
	func _process(delta):
		if masCha != null && is_instance_valid(eff2):
			eff2.position = masCha.position
	func _del():
		._del()
		if is_instance_valid(eff2):
			eff2.queue_free()
	func _upS():
		var hurtType = Chara.HurtType.MGI
		if masCha.isAwaken:hurtType = Chara.HurtType.REAL
		if rng == 1:
			for i in masCha.aroundCells:
				var cha = masCha.matCha(masCha.cell+i)
				if cha != null && cha.team != masCha.team:
					masCha.azurHurtChara(cha, min(cha.att.maxHp*0.6, masCha.getSkillEffect("剑刃风暴")), hurtType, Chara.AtkType.SKILL, "剑刃风暴")
		else:
			for cha in masCha.getCellChas(masCha.cell, rng, 1):
				masCha.azurHurtChara(cha, min(cha.att.maxHp*0.6, masCha.getSkillEffect("剑刃风暴")), hurtType, Chara.AtkType.SKILL, "剑刃风暴")
	func _onHurt(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.SKILL:
			atkInfo.hurtVal = 0