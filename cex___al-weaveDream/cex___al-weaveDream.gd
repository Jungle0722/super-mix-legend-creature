extends "../azurline_ctrl/Siren.gd"
func _info():
	pass
func _connect():
	._connect()
var allCell = []
func _extInit():
	._extInit()
	chaName = "「塞壬」织梦者·Lv%d"%level   #角色的名称
	lv = 3             #等级的设置
	attCoe.atkRan = 4  #攻击距离
	attCoe.maxHp = 5   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 5	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 5  #魔法攻击（每点代表13.7）
	attCoe.def = 5	#物理防御（每点代表15）
	attCoe.mgiDef = 5  #魔法防御（每点代表16.6）
	evos = ["cex___al-weaveDream2"]
	addSkill("每{cd}秒诅咒所有敌人，造成[法强*2]的可暴击伤害，并附加10层<霜冻>", "编织噩梦", "bzem", 10)
	addSkill("战斗开始时，随机复制5名敌方单位（包括装备、技能）", "梦境投影")
	if id == "cex___al-weaveDream":
		addSkillTxt("[color=#C0C0C0]参加18场战斗后，将进化为传奇单位[/color]")
	
func levelUp():
	.levelUp()
	updateAtt()

func updateAtt():
	updateTmpAtt("maxHp", 120, false)
	updateTmpAtt("atk", 10, false)
	updateTmpAtt("mgiAtk", 20, false)
	updateTmpAtt("def", 10, false)
	updateTmpAtt("mgiDef", 10, false)
	if level == 20 and gSiren.sirenAwaken:
		call("awaken")
		updateTmpAtt("maxHp", 1500, false)
		updateTmpAtt("atk", 150, false)
		updateTmpAtt("mgiAtk", 200, false)
		updateTmpAtt("def", 150, false)
		updateTmpAtt("mgiDef", 150, false)
		updateTmpAtt("mgiPenL", 0.5, false)
	upAtt()

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="mxfy":
		mxfy()
	if id=="bzem":
		bzem()

func mxfy():
	var chas = getAllChas(1)
	for i in chas:
		if i.hasBuff("b_weaveDream") == null:continue
		i.addBuff(b_weaveDream.new(8))
		for j in i.skills:
			j.nowTime += 4
var p1 = 2
func bzem():
	var chas = getAllChas(1)
	for i in chas:
		azurHurtChara(i, att.mgiAtk*p1, Chara.HurtType.MGI, Chara.AtkType.SKILL, "编织噩梦", true)
		i.addBuff(buffUtil.b_freeze.new(10))

func _onBattleStart():
	._onBattleStart()
	var chas = getAllChas(1)
	for i in chas:
		i.addBuff(buffUtil.b_cd.new(-2))
	var count = 0
	for i in chas:
		if count >= 6:break
		if i.get("type") == "BOSS":continue
		count += 1
		var cha = summChara(i.id)
		for j in i.items:
			cha.addItem(sys.newItem(j.id))
		if i.get("skillSlot") != null && cha.has_method("enemyGetSkill"):
			cha.enemyGetSkill(i.get("skillSlot"))
		if isAwaken:
			difficult.doAiChaBouns(cha)

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if lv == 3:return
	if atkInfo.hurtType == Chara.HurtType.PHY:
		atkInfo.hurtVal *= 0.5
	if atkInfo.hurtType == Chara.HurtType.MGI:
		atkInfo.factor += 0.2	

class b_weaveDream:
	extends Buff
	var dispel = 2
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_weaveDream"
