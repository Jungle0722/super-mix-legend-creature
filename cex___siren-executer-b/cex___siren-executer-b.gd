extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「高级塞壬」代行者·VIII"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atkRan = 5  #攻击距离
	attCoe.maxHp = 160   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 17	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 17  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）
	addSkill("开局随机获得3件装备，每10秒召唤一名随机3级舰娘，并使其获得10层<振奋>", "援军", "yj", 10)
	addSkill("每10秒弱驱散自身所有负面效果", "塞壬", "sr", 7)

	addSkill("<固化>每10秒杀掉一名随机非召唤敌方单位", "抹杀")
	addSkill("免疫普攻伤害", "模糊")
	addSkill("<限定>血量低于50%时，强制触发一次抹杀，获得5秒<无敌>", "应激")

	isHead = true
	giftCha = "cex___al-executer-b"
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="yj":
		yj()
	if id=="sr":
		sr()

func yj():
	var cha = summChara(sys.rndListItem(utils.lv3), true)
	cha.addBuff(buffUtil.b_zhenFen.new(10))

func _onBattleStart():
	._onBattleStart()
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("DEF")))
	skFlag = 0
	skFlag2 = true

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		atkInfo.hurtVal = 0

func _onHurtEnd(atkInfo):
	._onHurtEnd(atkInfo)
	if skFlag2 and att.hp/att.maxHp <= 0.5:
		addBuff(buffUtil.b_wudi.new(5))
		moSha()
		skFlag2 = false

var skFlag = 0
var skFlag2 = true
func _upS():
	._upS()
	skFlag += 1
	if skFlag >= 10:
		moSha()
		skFlag = 0
		
func moSha():
	var chas = getAllChas(1)
	chas.shuffle()
	for i in chas:
		if i.isSumm:continue
		i.forceHurtSelf(i.att.maxHp)
		increDmgNum(i.att.maxHp, "抹杀", i)
		break
	