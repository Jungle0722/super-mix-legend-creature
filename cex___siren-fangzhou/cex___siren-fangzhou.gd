extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「神秘」皇家方舟·黑化"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atkRan = 4  #攻击距离
	attCoe.maxHp = 120   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 20	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 20  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）
	attAdd.mgiSuck += 0.2
	addSkill("开局随机获得3件装备，每{cd}秒召唤一名继承自身装备的随机4级舰娘", "援军", "yj", 10)
	addSkill("每{cd}秒清除自身所有负面状态", "塞壬之力", "sr", 5)

	addSkill("每{cd}秒对随机3个敌人的方向射出3发枪焰，分别对直线上的敌人造成[法强*3]的伤害，\n					并附带20层漏水", "烬火枪焰", "sk_fangzhou1", 8)
	addSkill("每{cd}秒对随机三分之一的敌人进行标记，若敌人被标记2次，则造成[法强*5]的真实伤害，\n					被标记3次，则直接受到[血上限80%]的真实伤害", "幻影强袭", "sk_fangzhou2", 8)
	addSkill("本回合每击杀1名非召唤敌方单位，提高30%法强、冷却速度(上限300%)<高强度>", "荣光之锋")

	isHead = true
	giftCha = "cex___al-fangzhou"

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="yj":
		yj()
	if id=="sr":
		sr()
	if id == "sk_fangzhou1":
		sk_fangzhou1()
	if id == "sk_fangzhou2":
		sk_fangzhou2()

func yj():
	summChara(sys.rndListItem(utils.lv4), true)

func _onBattleStart():
	._onBattleStart()
	addItem(sys.newItem(utils.getRandomItem("MGI")))
	addItem(sys.newItem(utils.getRandomItem("MGI")))
	addItem(sys.newItem(utils.getRandomItem("DEF")))

#烬火枪焰
func sk_fangzhou1():
	for i in utils.getRndEnemys(self, 3):
		var eff:Eff = newEff("sk_feiZhan",sprcPos)
		eff._initFlyPos(position + (aiCha.position - position).normalized() * 1000, 800)
		eff.connect("onInCell",self,"effInCell")

func effInCell(cell):
	var cha = matCha(cell)
	if cha == null:
		cha = matCha(cell + Vector2(0, 1))
	if cha != null && cha.team != team :
		var dmg = att.mgiAtk * 3
		azurHurtChara(cha, min(cha.att.maxHp*1.2, dmg), Chara.HurtType.MGI, Chara.AtkType.SKILL, "烬火枪焰")
		buffUtil.addLouShui(cha, self, 20)

var flagedChas = {}
#幻影强袭
func sk_fangzhou2():
	var chas = getAllChas(1)
	var index = 0
	for i in chas:
		if index > chas.size()/3:break
		if i.get("tag") != "azurline":continue
		index += 1
		utils.dicPlus(flagedChas, i, 1)
		if flagedChas.get(i) == 2:
			azurHurtChara(i, min(i.att.maxHp*1.2, att.mgiAtk * 5), Chara.HurtType.REAL, Chara.AtkType.SKILL, "幻影强袭")
		elif flagedChas.get(i) > 2:
			azurHurtChara(i, i.att.maxHp*0.8, Chara.HurtType.REAL, Chara.AtkType.SKILL, "幻影强袭")

func _onBattleEnd():
	._onBattleEnd()
	flagedChas = {}
			
func _onKillChara(atkInfo):
	._onKillChara(atkInfo)	
	if atkInfo.hitCha.isSumm:return
	var bf = hasBuff("b_fangzhou")
	if bf == null:
		bf = addBuff(b_fangzhou.new())
	if bf.att.mgiAtkL < 3:
		bf.att.mgiAtkL += 0.3
		bf.att.cd += 0.3

class b_fangzhou:
	extends Buff
	var buffName = "荣光之锋"
	var dispel = 2
	func _init(num = 0):
		attInit()
		id = "b_fangzhou"	
		att.mgiAtkL = 0
		att.spd = 0