extends "../azurline_ctrl/Siren.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」侵扰者Ⅲ型·Lv%d"%level    #角色的名称
	lv = 3
	attCoe.atkRan = 4#攻击距离
	attCoe.maxHp = 4#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 4     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 4  #魔法攻击（每点代表13.7）
	attCoe.def = 4     #物理防御（每点代表15）
	attCoe.mgiDef = 4#魔法防御（每点代表16.6）
	evos = ["cex___al-intruder32"]

	addSkill("每{cd}秒召唤一名随机3级舰娘，并使其获得10层[狂怒][急速]", "援军", "yj", 10)
	addSkill("<先手>每{cd}秒对全体敌人造成[物攻*1]的伤害", "强袭", "qiXi", 10)
	addSkill("敌方造成的魔法伤害有35%几率落空<强效果>", "电磁伪装")

	if id == "cex___al-intruder3":
		addSkillTxt("[color=#C0C0C0]参加18场战斗后，将进化为传奇单位[/color]")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="qlgr":
		qlgr()
	if id=="qiXi":
		qiXi()
	if id=="yj":
		yj()

func qlgr():
	var chas = getAllChas(1)
	for i in chas:
		i.addBuff(buffUtil.b_blindness.new(8))
		if isAwaken:
			buffUtil.addBaoLu(i, 2)

func levelUp():
	.levelUp()
	updateAtt()

func updateAtt():
	updateTmpAtt("maxHp", 150, false)
	updateTmpAtt("atk", 10, false)
	updateTmpAtt("mgiAtk", 15, false)
	updateTmpAtt("def", 10, false)
	updateTmpAtt("mgiDef", 10, false)
	updateTmpAtt("cd", 0.02, false)
	if level == 20 and gSiren.sirenAwaken:
		call("awaken")
		updateTmpAtt("maxHp", 1000, false)
		updateTmpAtt("atk", 100, false)
		updateTmpAtt("mgiAtk", 150, false)
		updateTmpAtt("def", 150, false)
		updateTmpAtt("mgiDef", 150, false)
		updateTmpAtt("cd", 0.2, false)
	upAtt()

func qiXi():
	utils.createSkillTextEff("强袭", position)
	var chas = getAllChas(1)
	for i in chas:
		if upgraded:
			i.addBuff(buffUtil.b_freeze.new(5))
			i.addBuff(buffUtil.b_liuXue_r.new(5))
		azurHurtChara(i, att.atk*1, Chara.HurtType.PHY, Chara.AtkType.EFF, "强袭")
		
func yj():
	var cha = summChara(sys.rndListItem(utils.lv3))
	if cha != null:
		cha.addBuff(buffUtil.b_kuangNu_r.new(10))
		cha.addBuff(buffUtil.b_jiSu_r.new(10))

func _onBattleStart():
	._onBattleStart()
	for i in getAllChas(1):
		i.addBuff(b_intruder3.new())
	
class b_intruder3:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_intruder3"
	func _connect():
		masCha.connect("onAtkChara",self,"run")
	func run(atkInfo):
		if atkInfo.hurtType == Chara.HurtType.MGI and sys.rndPer(35):
			atkInfo.hurtVal = 0
