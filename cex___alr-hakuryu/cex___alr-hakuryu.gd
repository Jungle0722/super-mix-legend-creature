extends "../cazurlineE/cazurlineE.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「航母」白龙"
	attCoe.atkRan = 4  #攻击距离
	attCoe.maxHp += 4   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 4     #攻击力（每点代表8.5）
	attCoe.def += 3     #物理防御（每点代表15）
	attCoe.mgiDef += 3     #物理防御（每点代表15）
	lv = 3
	isResearch = true
	autoGetSkill()
	ename = "bailong"
	addSkill("每{cd}秒审判罪孽最为深重之人(伤害最高的敌人)，对其造成[法强*7]({damage})的真实伤害，\n并<放逐>2秒", "天雷罪灭", "tianleizm", 10)
	addSkill("每{cd}秒为所有敌人附加6层<烧蚀>，若目标烧蚀达到20层，则对其触发[天雷罪灭]\n(同一个目标5秒内无法连续被审判)", "锋焰显征", "fengyanxz", 10)

	setCamp("重樱")
	evos = ["cex___alr-hakuryu2"]
	canCopy = false
	supportSpecEvo = 2

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="tianleizm":
		tianleizm()
	if id=="fengyanxz":
		fengyanxz()
var record = {}
func _onBattleEnd():
	._onBattleEnd()
	record.clear()

func getEnemyByDmg():
	var values = azurCtrl.statis2.values()
	values.sort_custom(self, "sortStatis")
	for i in values:
		if not i.cha.isDeath and i.cha.hasBuff("b_hakuryu") == null:
			return i.cha
	return null

func tianleizm(cha = null, flag = true):
	if cha == null:cha = getEnemyByDmg()
	if cha == null:return
	createCustEff(cha.position, "eff/thunder", 10, false, 2, Vector2(0, -20))
	var p = 1
	if not flag:p *= 0.5
	var n = utils.dicGet(record, cha, 0)
	p *= (1 + n * 0.5)
	azurHurtChara(cha, getSkillEffect("天雷罪灭") * p, Chara.HurtType.REAL, Chara.AtkType.SKILL, "天雷罪灭")
	utils.dicPlus(record, cha, 1)
	if not cha.isDeath and cha.hasBuff("b_fangZhu") == null and flag and cha.hasBuff("b_hakuryu") == null:
		var fz = 2
		if cha.get("type") == "BOSS":fz = 1
		cha.addBuff(buffUtil.b_fangZhu.new(fz))

	if isAwaken:
		cha.addBuff(b_hakuryu.new(2))
	else:
		cha.addBuff(b_hakuryu.new(5))
		
func fengyanxz():
	for i in getAllChas(1):
		i.addBuff(buffUtil.b_shaoShi.new(6))
		var bf = i.hasBuff("b_shaoShi")
		if bf.life >= 19:
			tianleizm(i)

func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "天雷罪灭":
		return att.mgiAtk * 7		

class b_hakuryu:
	extends Buff
	var dispel = 2
	func _init(lv = 1):
		attInit()
		id = "b_hakuryu"
		life = lv