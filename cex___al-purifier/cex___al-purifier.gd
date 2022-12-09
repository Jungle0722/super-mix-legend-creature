extends "../azurline_ctrl/Siren.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「塞壬」净化者·Lv%d"%level    #角色的名称
	lv = 3             #等级的设置
	attCoe.atkRan = 4#攻击距离
	attCoe.maxHp = 5#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 4     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 4  #魔法攻击（每点代表13.7）
	attCoe.def = 4     #物理防御（每点代表15）
	attCoe.mgiDef = 4#魔法防御（每点代表16.6）
	atkEff = "atk_gongJian" #攻击时的特效
	evos = ["cex___al-purifier2"]
	addSkill("每{cd}秒对正面效果最多的敌人造成[法强*正面效果数]的伤害，并弱驱散其所有正面效果", "净化", "jh", 10)
	addSkill("每阵亡5名非召唤友方单位，对随机敌方单位造成[目标血上限*0.99]的真实技能伤害", "天选")
	addSkill("每{cd}秒对目标一格内的所有敌人造成[法强*1.5]的伤害，并附加5层<灼烧>", "神火", "sh", 6)
	if id == "cex___al-purifier":
		addSkillTxt("[color=#C0C0C0]参加18场战斗后，将进化为传奇单位[/color]")
	
func levelUp():
	.levelUp()
	updateAtt()
	
func updateAtt():
	updateTmpAtt("maxHp", 50, false)
	updateTmpAtt("atk", 10, false)
	updateTmpAtt("mgiAtk", 10, false)
	updateTmpAtt("def", 10, false)
	updateTmpAtt("mgiDef", 10, false)
	if level == 20 and gSiren.sirenAwaken:
		call("awaken")
		updateTmpAtt("maxHp", 1000, false)
		updateTmpAtt("atk", 100, false)
		updateTmpAtt("mgiAtk", 100, false)
		updateTmpAtt("def", 100, false)
		updateTmpAtt("mgiDef", 100, false)
	upAtt()

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="jh":
		jh()
	if id=="sh":
		sh()
	if id=="wy":
		wy()

var summ = utils.lv3
func jh():
	var chas = getAllChas(1)
	chas.sort_custom(self, "sort1")
	var cha = chas[0]
	var buffNum = 0
	for j in cha.buffs:
		if not j.isNegetive && j.get("type") != config.EQUITYPE_EQUI && j.get("dispel") != 2 and j.get("dispel") != 3:
			buffNum += 1
			j.isDel = true
	azurHurtChara(cha, att.mgiAtk*buffNum, Chara.HurtType.MGI, Chara.AtkType.SKILL, "净化")

func sort1(a,b):
	return countBuffs(a) > countBuffs(b)

func countBuffs(cha):
	var buffNum = 0
	for j in cha.buffs:
		if not j.isNegetive && j.get("type") != config.EQUITYPE_EQUI && j.get("dispel") != 2 and j.get("dispel") != 3:
			buffNum += 1
	return buffNum
			
var count = 0
func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha):return
	if cha.team == team:
		count += 1
	if count >= 5:
		var c = utils.getRndEnemy(self)
		azurHurtChara(c, c.att.maxHp*0.99, Chara.HurtType.REAL, Chara.AtkType.EFF, "天选")
		count = 0

func _onBattleEnd():
	._onBattleEnd()
	count = 0
#神火系数	
var p3 = 1.5
func sh():
	if aiCha != null:
		var eff:Eff = newEff("sk_yunShi")
		eff.position = aiCha.position
		var chas = getCellChas(aiCha.cell,1,1)
		for i in chas: 
			azurHurtChara(i, att.mgiAtk*p3, Chara.HurtType.MGI, Chara.AtkType.SKILL, "神火")
			i.addBuff(buffUtil.b_shaoZhuo_r.new(5))

func wy():
	var chas = getAllChas(1)
	for i in chas: 
		i.addBuff(utils.buffs.b_shaoShi.new(10, self))
		if isAwaken:
			azurHurtChara(i, i.att.mgiDef*8, Chara.HurtType.REAL, Chara.AtkType.SKILL, "威压")
		else:
			azurHurtChara(i, i.att.mgiDef*8, Chara.HurtType.MGI, Chara.AtkType.SKILL, "威压")

func sr():
	for i in buffs:
		if i.isNegetive:
			i.isDel = true
