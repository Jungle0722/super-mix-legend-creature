extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「辅助」伊19"   #角色的名称
	attCoe.atkRan = 5#攻击距离
	attCoe.maxHp = 3#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 1     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 5  #魔法攻击（每点代表13.7）
	attCoe.def = 1     #物理防御（每点代表15）
	attCoe.mgiDef = 1#魔法防御（每点代表16.6）
	lv = 2             #等级的设置
	atkEff = "atk_dang" #攻击时的特效
	evos = ["cazurlineF_1_1","cazurlineF_1_2","cazurlineF_1_3"]
	type2 = "ss"
	addSkill("无法进行普通攻击，受到的物理伤害降低50%，对传奇单位造成额外40%伤害", "潜航")
	addSkill("<先手>每{cd}秒发射一枚潜射鱼雷，对一条直线上的敌人造成[法强*2]({damage})的魔法伤害", "潜射鱼雷", "qsyl", 8)
	type = "sup"
	setGunAndArmor("小型","轻型")
	setCamp("铁血")

func normalAtkChara(cha):
	pass	

func _onBattleStart():
	._onBattleStart()
	addBuff(buffUtil.b_sniper.new())
	yield(reTimer(0.1),"timeout")
	qsyl()

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="qsyl":
		qsyl()

func qsyl():
	if aiCha != null:
		var eff:Eff = newEff("sk_chuanTouJian",sprcPos)
		eff._initFlyPos(position + (aiCha.position - position).normalized() * 1000,250)
		eff.connect("onInCell",self,"effInCell")
	
func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.hurtType == Chara.HurtType.PHY:
		atkInfo.hurtVal *= 0.5

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.hitCha.lv > 3 and atkInfo.hurtVal > 0:
		atkInfo.factor += 0.4

func effInCell(cell):
	var cha = matCha(cell)
	if cha == null:
		cha = matCha(cell + Vector2(0, 1))
	if cha != null && cha.team != team:
		azurHurtChara(cha, min(cha.att.maxHp*1.2, getSkillEffect("潜射鱼雷")), Chara.HurtType.MGI, Chara.AtkType.SKILL, "潜射鱼雷")

func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "潜射鱼雷":
		return att.mgiAtk * 2
	elif name == "陨落双鲨":
		return att.mgiAtk * 10
	elif name == "西进之戟":
		return att.mgiAtk * 4