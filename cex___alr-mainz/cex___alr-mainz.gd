extends "../cazurlineB/cazurlineB.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「轻巡」美因茨"
	attCoe.atkRan = 5  #攻击距离
	attCoe.maxHp += 3   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 5     #攻击力（每点代表8.5）
	attCoe.def += 3     #物理防御（每点代表15）
	attCoe.mgiDef += 3     #物理防御（每点代表15）
	lv = 3
	isResearch = true
	addSkill("每次造成伤害有8%几率对当前目标及其周围(十字范围)敌人造成2秒<眩晕>", "战术压制")
	addSkill("每{cd}秒对护甲最低的敌人连开6枪，每枪造成[攻击60%]({damage})的普攻伤害", "快速射击", "quickShoot", 6)
	addSkill("每触发3次快速射击，进入4秒蓄力状态(蓄力期间受到300%伤害，无法攻击)，蓄力结束后，\n		对最近的5个敌人造成5次[攻击*5]({damage})的普攻伤害", "审判")

	autoGetSkill()
	setCamp("铁血")
	setGunAndArmor("中型","中型")
	evos = ["cex___alr-mainz2"]
	canCopy = false
	supportSpecEvo = 2

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "quickShoot":
		quickShoot()

func quickShoot():
	var cha = getFirstCha(1, "sortByDef")
	if cha != null:
		skIndex += 1
		for i in range(6):
			if cha.isDeath:break
			azurHurtChara(cha, getSkillEffect("快速射击"), Chara.HurtType.PHY, Chara.AtkType.NORMAL, "快速射击")
		if skIndex >= 3:
			skIndex = 0
			judge()

func judge():
	addBuff(b_mainz.new(4))
	yield(reTimer(4), "timeout")

func normalAtkChara(cha):
	if hasBuff("b_mainz") == null:
		.normalAtkChara(cha)

func dojudge():
	utils.createSkillTextEff("审判", position)
	var chas = getAllChas(1)
	chas.sort_custom(self, "sortByDistance")
	var dmg = getSkillEffect("审判")
	if isAwaken:dmg *= 1.5
	for i in range(5):
		if i >= chas.size():break
		for j in range(5):
			if chas[i].isDeath:continue
			azurHurtChara(chas[i], dmg, Chara.HurtType.PHY, Chara.AtkType.NORMAL, "审判")

var skIndex = 0
func _onBattleStart():
	._onBattleStart()
	if upgraded:
		judge()

func _onBattleEnd():
	._onBattleEnd()
	skIndex = 0
	
class b_mainz:
	extends Buff
	var buffName = "蓄力"
	var dispel = 3
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_mainz"
		att.defR = -3
	func _del():
		._del()
		masCha.dojudge()