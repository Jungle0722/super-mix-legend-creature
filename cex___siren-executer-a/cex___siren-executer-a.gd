extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「高级塞壬」代行者·III"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atkRan = 5  #攻击距离
	attCoe.maxHp = 140   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 15	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 15  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）
	addSkill("开局随机获得3件装备，每10秒召唤一名随机3级舰娘，并使其获得10层[狂怒][急速]", "援军", "yj", 10)
	
	addSkill("<先手>每10秒对所有敌人造成[攻击*0.5]的技能伤害，本回合内，本技能每次使用后伤害翻倍", "徐进弹幕", "xjdm", 10)
	addSkill("降低所有敌人40%暴击、爆伤<弱效果>", "抗暴立场")
	addSkill("对暴击率越低的敌人，造成的伤害越高", "以暴制暴")
	
	addSkill("每4秒弱驱散自身所有负面效果", "塞壬", "sr", 4)
	isHead = true
	giftCha = "cex___al-executer-a"
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="yj":
		yj()
	if id=="sr":
		sr()
	if id=="xjdm":
		xjdm()

func yj():
	var cha = summChara(sys.rndListItem(utils.lv3), true)
	cha.addBuff(buffUtil.b_kuangNu_r.new(10))
	cha.addBuff(buffUtil.b_jiSu_r.new(10))

func _onBattleStart():
	._onBattleStart()
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("DEF")))
	p1 = 0.5
	xjdm()
	for i in getAllChas(1):
		i.addBuff(b_executer_a.new())

var p1 = 0.5
func xjdm():
	for i in getAllChas(1):
		azurHurtChara(i, att.atk*p1, Chara.HurtType.PHY, Chara.AtkType.SKILL, "徐进弹幕")
	p1 *= 2

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	var num = atkInfo.hitCha.att.cri - 0.2
	if num > 0:
		num = 1
	else:
		num = 1 - num
	atkInfo.hurtVal *= num
			
class b_executer_a:
	extends Buff
	var buffName = "抗暴立场"
	func _init():
		attInit()
		id = "b_executer_a"
		isNegetive = true
		att.cri = -0.4
		att.criR = -0.4