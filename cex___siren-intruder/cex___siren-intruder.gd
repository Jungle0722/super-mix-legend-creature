extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「高级塞壬」侵扰者"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atkRan = 5  #攻击距离
	attCoe.maxHp = 150   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 15	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 15  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）
	attAdd.spd += 0.5
	attAdd.cd += 0.4
	addSkill("开局随机获得3件装备，召唤1名2级塞壬，每{cd}秒召唤一名随机3级舰娘，并使其获得10层[狂怒][急速]", "援军", "yj", 12)
	addSkill("每{cd}秒对全体敌人造成[物攻*2]的伤害", "强袭", "qiXi", 10)
	addSkill("普攻对当前目标身后一排的所有单位造成[物攻*1]的伤害", "势如破竹")
	addSkill("每{cd}秒弱驱散自身所有负面状态", "塞壬", "sr", 4)

	isHead = true
	giftCha = "cex___al-intruder"
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="qiXi":
		qiXi()
	if id=="yj":
		yj()
	if id=="sr":
		sr()

func qiXi():
	var chas = getAllChas(1)
	for i in chas:
		azurHurtChara(i, min(i.att.maxHp*1.2, att.atk*2), Chara.HurtType.PHY, Chara.AtkType.EFF, "强袭")
		
func yj():
	var cha = summChara(sys.rndListItem(utils.lv3), true)
	if cha != null:
		cha.addBuff(buffUtil.b_kuangNu_r.new(10))
		cha.addBuff(buffUtil.b_jiSu_r.new(10))

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		qx(atkInfo.hitCha)

func qx(cha):
	var eff:Eff = newEff("sk_feiZhan",sprcPos)
	eff._initFlyPos(position + (cha.position - position).normalized() * 800, 800)
	eff.connect("onInCell",self,"effInCell")

func effInCell(cell):
	var cha = matCha(cell)
	if cha == null:
		cha = matCha(cell + Vector2(0, 1))
	if cha != null && cha.team != team :
		azurHurtChara(cha, min(cha.att.maxHp*1.2, att.atk*1), Chara.HurtType.PHY, Chara.AtkType.SKILL, "势如破竹")
		
func _onBattleStart():
	._onBattleStart()
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("DEF")))
	summChara(sys.rndListItem(gSiren.leaders)%[2])