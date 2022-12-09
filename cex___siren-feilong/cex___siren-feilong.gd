extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「神秘」飞龙·黑化"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atkRan = 4  #攻击距离
	attCoe.maxHp = 100   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 20	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 15  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）
	attAdd.spd += 1.5
	attAdd.suck += 0.2
	addSkill("开局随机获得3件装备，每{cd}秒召唤一名继承自身装备的随机4级舰娘", "援军", "yj", 5)
	addSkill("每{cd}秒清除自身所有负面状态", "塞壬之力", "sr", 4)
	
	addSkill("普攻后，指挥我方角色对目标发起普攻(内置冷却1秒)", "烬火之刃")
	addSkill("对同一个敌人造成的普攻伤害，每次提高50%(上限500%)", "光暗花札")
	addSkill("本回合内，我方角色阵亡时，获得其10%攻击(上限5000)<高强度>", "战忆之樱")

	isHead = true
	giftCha = "cex___al-feilong"

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="yj":
		yj()
	if id=="sr":
		sr()

func yj():
	summChara(sys.rndListItem(utils.lv4), true)

func _onBattleStart():
	._onBattleStart()
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("DEF")))

func _onNormalAtk(cha):
	._onNormalAtk(cha)
	if skFlag:
		skFlag = false
		for i in getAllChas(2):
			if not cha.isDeath:
				i.normalAtkChara(cha)

var skFlag = true
func _upS():
	._upS()
	skFlag = true

var skNum = 1
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		atkInfo.hurtVal *= skNum
		if skNum <= 6:
			skNum += 0.5

func _onBattleEnd():
	._onBattleEnd()
	skNum = 1

func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha) or not isAwaken:return
	if cha.team == 2:
		var bf = hasBuff("b_feilong")
		if bf == null:
			bf = addBuff(b_feilong.new())
		if bf.att.atk < 5000:
			bf.att.atk += cha.att.atk * 0.1

class b_feilong:
	extends Buff
	var buffName = "战忆之樱"
	var dispel = 2
	func _init(num = 0):
		attInit()
		id = "b_feilong"	
		att.atk = num