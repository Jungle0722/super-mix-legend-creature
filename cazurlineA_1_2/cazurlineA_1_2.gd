extends "../cazurlineA_1/cazurlineA_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」恶毒"   #角色的名称
	lv = 3             #等级的设置
	addSkill("每{cd}秒对法强最高的敌人造成[法强+目标法强]的伤害，并降低其40%法强", "嫉妒", "jiDu", 6)
	autoGetSkill()
	evos = ["cazurlineA_1_2_1"]
	setCamp("自由鸢尾")
	itemEvoCha2 = "cex___almiu-malin"
	ename = "edu"
var jiduFlag = false
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "jiDu":
		jiDu()

func jiDu(cha = null):
	utils.createSkillTextEff("嫉妒", position)
	if cha == null:
		var chas = getAllChas(1)
		chas.sort_custom(self,"sortEd")
		if chas.size() > 0:
			cha = chas[0]
	azurHurtChara(cha, cha.att.mgiAtk + att.mgiAtk, Chara.HurtType.MGI, Chara.AtkType.SKILL, "嫉妒")
	if cha.hasBuff("b_malin") != null:return
	if not jiduFlag:
		cha.addBuff(b_malin.new(4))
	else:
		if cha.get("type") == "BOSS":
			cha.addBuff(b_malin.new(2.5, 2))
		else:
			cha.addBuff(b_malin.new(5, 2))

func sortEd(a,b):
	return a.att.mgiAtk > b.att.mgiAtk

class b_malin:
	extends Buff
	var buffName = "嫉妒"
	var dispel = 2
	func _init(num = 5, dis = 1):
		attInit()
		id = "b_malin"	
		isNegetive = true
		att.mgiAtkL = -0.1*num
		dispel = dis
