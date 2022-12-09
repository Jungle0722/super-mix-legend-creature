extends "../cazurlineC_5/cazurlineC_5.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「重巡」伊吹"   #角色的名称
	attCoe.atk += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cazurlineC_5_2_1"]
	addSkill("<限定>死亡后以半血复活，并进入<心神合一>状态", "心神合一")

	autoGetSkill()
	setCamp("重樱")

func _onDeath(atkInfo):
	._onDeath(atkInfo)
	if not isSurvive1 or not isDeath:
		isSurvive1 = true
		isDeath = false
		healCha(self, att.maxHp*0.5)
		addBuff(b_yc_xshy.new())
		if upgraded:
			yc_hx()
var p3 = 1#普攻增伤系数
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL and isAwaken:
		atkInfo.hurtVal *= p3

func yc_hx():
	utils.createSkillTextEff("回响", position)
	for i in getAllChas(2):
		if i.has_method("deathWord"):
			i.deathWord()
			if isAwaken and p3 < 4:p3 += 0.1
		for j in i.items:
			if j.has_method("deathWord") and sys.rndPer(50):
				j.deathWord()

class b_yc_xshy:
	extends Buff
	var buffName = "心神合一"
	var dispel = 2
	func _init():
		attInit()
		id = "b_yc_xshy"
	func _connect():
		masCha.connect("normalAtkChara",self,"run")
	func run(atkCha):
		var p = 50
		if masCha.isAwaken:p = 100
		if sys.rndPer(p):
			for i in range(6):
				var cha = masCha.matCha(Vector2(atkCha.cell.x, i))
				if cha != null && cha.team != masCha.team:
					createEff(cha)
					masCha.normalAtk(cha)
	func createEff(cha):
		var eff2 = sys.newEff("animEff", cha.position)
		eff2.setImgs(masCha.direc + "eff/zhan", 6, false)
		eff2.scale *= 0.3
		eff2.normalSpr.position=Vector2(0, -40)