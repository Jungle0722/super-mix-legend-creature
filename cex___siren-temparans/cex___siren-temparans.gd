extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「高级塞壬」仲裁者·天帕岚斯·XIV"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atkRan = 5  #攻击距离
	attCoe.maxHp = 240   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 20	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 20  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）
	attAdd.spd += 1
	attAdd.penL += 0.4
	attAdd.suck += 0.2

	addSkill("开局随机获得3件装备，每{cd}秒召唤一名随机4级舰娘，并使其继承自身装备", "援军", "yj", 20)
	addSkill("每{cd}秒，召唤两名带亡语效果的传奇舰娘，使其继承自身装备", "冥界卫士", "mingJie", 10)
	addSkill("每{cd秒，触发所有友军的亡语效果", "执掌轮回", "lunHui", 11)
	addSkill("队友死亡时，获得50点攻击、20%攻速，并对当前目标造成[攻击*5]的物理伤害", "逝者之力")
	addSkill("每{cd}秒清除自身所有负面状态", "塞壬", "sr", 4)
	isHead = true

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="mingJie":
		mingJie()
	if id=="lunHui":
		lunHui()
	if id=="yj":
		yj()
	if id=="sr":
		sr()

func mingJie():
	for i in range(2):
		summChara(sys.rndListItem(utils.deathWordChas), true)

func lunHui():
	for i in getAllChas(2):
		if i.has_method("deathWord"):
			i.deathWord()

func _onBattleStart():
	._onBattleStart()
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("DEF")))
	if difficult.difficult > 2:
		for i in items:
			if i.get("upgraded") != null:
				i.upgrade()
			else:
				difficult.itemUpgrade(i)
		learnRndSkill()

func yj():
	var cha = summChara(sys.rndListItem(utils.lv4), true)
	if cha.has_method("upgrade"):
		cha.upgrade()
		cha.upgraded = true
	if difficult.difficult > 5:
		cha.addBuff(buffUtil.b_zhenFen.new(20))

func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha):return
	if cha.team == team:
		var atk = 50
		var spd = 0.2
		var buff = hasBuff("b_temparans")
		if buff == null:
			addBuff(b_temparans.new(atk, spd))
		else:
			buff.att.atk += atk
			buff.att.spd += spd
		azurHurtChara(aiCha, min(cha.att.maxHp*2, att.atk*5), Chara.HurtType.PHY, Chara.AtkType.SKILL, "逝者之力", true)

class b_temparans:
	extends Buff
	var dispel = 2
	func _init(atk, spd):
		attInit()
		id = "b_temparans"	
		att.atk = atk
		att.spd = spd
	