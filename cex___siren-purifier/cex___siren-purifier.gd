extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「高级塞壬」净化者"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atkRan = 5  #攻击距离
	attCoe.maxHp = 220   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 25	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 22  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）
	attAdd.penL += 0.3
	attAdd.mgiSuck += 0.1
	lv = 4			 #等级的设置
	atkEff = "atk_gongJian" #攻击时的特效

	addSkill("开局随机获得3件装备，每{cd}秒召唤一名随机4级舰娘，并使其继承自己的装备", "援军", "yj", 10)
	addSkill("每{cd}秒对正面效果最多的敌人造成[法强*正面效果数]的伤害，并弱驱散其所有正面效果", "净化", "jh", 6)
	addSkill("每阵亡4名友方单位，对随机敌方单位造成[目标血上限*0.99]的真实技能伤害", "天选")
	addSkill("每{cd}秒对目标一格内的所有敌人造成[法强*3]的伤害", "神火", "sh", 5)
	addSkill("每{cd}秒对所有敌人造成[目标魔抗*正面效果数]的真实伤害，并附加5层<烧蚀>", "威压", "wy", 10)
	addSkill("每{cd}秒清除自身所有负面效果", "塞壬", "sr", 7)

	isHead = true
	giftCha = "cex___al-purifier"

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="yj":
		yj()
	if id=="jh":
		jh()
	if id=="sh":
		sh()
	if id=="wy":
		wy()
	if id=="sr":
		sr()

var summ = utils.lv3
func yj():
	var cha = summChara(sys.rndListItem(utils.lv4), true)
	if sys.rndPer(50) and cha.has_method("upgrade"):
		cha.upgrade()
		cha.upgraded = true

func jh():
	var chas = getAllChas(1)
	chas.sort_custom(self, "sort1")
	var cha = chas[0]
	var buffNum = 0
	for j in cha.buffs:
		if not j.isNegetive && j.get("type") != config.EQUITYPE_EQUI && j.get("dispel") != 2 and j.get("dispel") != 3:
			buffNum += 1
			j.isDel = true
	azurHurtChara(cha, min(cha.att.maxHp*1.2, att.mgiAtk*buffNum), Chara.HurtType.MGI, Chara.AtkType.SKILL, "净化")

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
	if count >= 4:
		var c = utils.getRndEnemy(self)
		azurHurtChara(c, c.att.maxHp*0.99, Chara.HurtType.REAL, Chara.AtkType.SKILL, "天选")
		count = 0

func _onBattleEnd():
	._onBattleEnd()
	count = 0

func sh():
	if aiCha != null:
		var chas = getCellChas(aiCha.cell,1,1)
		var eff:Eff = newEff("sk_yunShi")
		eff.position = aiCha.position
		yield(reTimer(0.45),"timeout")
		for i in chas: 
			azurHurtChara(i, att.mgiAtk*3, Chara.HurtType.MGI, Chara.AtkType.SKILL, "神火")

func wy():
	var chas = getAllChas(1)
	for i in chas: 
		azurHurtChara(i,  min(i.att.maxHp*1.2, i.att.mgiDef*countBuffs(i)), Chara.HurtType.REAL, Chara.AtkType.SKILL, "威压")
		i.addBuff(utils.buffs.b_shaoShi.new(5, self))

func _onBattleStart():
	._onBattleStart()
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("MGI")))
	addItem(sys.newItem(utils.getRandomItem("DEF")))

