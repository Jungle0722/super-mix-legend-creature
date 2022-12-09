extends "../cazurlineA/cazurlineA.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」标枪"   #角色的名称
	attCoe.mgiAtk += 2  #魔法攻击（每点代表13.7）
	attCoe.mgiDef += 2
	attCoe.def += 2
	attCoe.maxHp += 2
	lv = 3             #等级的设置
	evos = ["cex___als-javelin2"]
	canCopy = false
	type = "dd"
	addSkill("每{cd}秒向当前目标投掷反舰标枪，降低目标100魔抗并对目标周围(十字范围)造成[法强*4]({damage})的可暴击技能伤害(不可驱散)", "皇家标枪", "sk_javelin1", 5)
	ename = "biaoqiang"
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("皇家")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="sk_javelin1" and aiCha != null:
		sk_javelin1()

func sk_javelin1(cha = aiCha):
	if cha.att.mgiDef > 0:
		cha.addBuff(b_javelin.new())
	if upgraded:
		cha.addBuff(buffUtil.b_shaoShi.new(6))
		cha.addBuff(buffUtil.b_liuXue_r.new(6))
		buffUtil.addLouShui(cha, self, 6)
	createFlyEff(sprcPos, cha, "sk_feiDang")
	for i in getCellChas(cha.cell, 1, 1):
		azurHurtChara(i, getSkillEffect("皇家标枪"), Chara.HurtType.MGI, Chara.AtkType.SKILL, "皇家标枪", true)

class b_javelin:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_javelin"	
		att.mgiDef = -100