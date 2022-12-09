extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「辅助」阿贝克隆比"   #角色的名称
	attCoe.maxHp = 3#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 4     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 2  #魔法攻击（每点代表13.7）
	attCoe.def = 2     #物理防御（每点代表15）
	attCoe.mgiDef = 2#魔法防御（每点代表16.6）
	attCoe.atkRan = 4
	lv = 2             #等级的设置
	evos = ["cazurlineF_3_1", "cazurlineF_3_2"]
	addSkill("活着就是为了打炮，无法普攻，开局及每{cd}秒狠狠地打一炮，造成[物攻*3]({damage})的可暴击物理伤害", "浅水重炮舰", "fire", 6)
	addSkill("开炮时对敌人身后2格的目标造成100%的伤害，并附加4层<烧蚀><灼烧>", "HEAP")
	type = "sup"
	setGunAndArmor("大型","轻型")
	setCamp("皇家")

func normalAtkChara(cha):
	pass

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "fire":
		fire(aiCha)

func fire(cha = null, isCri = false):
	if cha == null:return
	createFlyEff(sprcPos, cha, "sk_4_1_2")
	doFire(aiCha)
	var p = -1
	if team == 1:
		p = 1
	var mcha1 = matCha(aiCha.cell + Vector2(p*1, 0))
	var mcha2 = matCha(aiCha.cell + Vector2(p*2, 0))
	if mcha1 != null && mcha1.team != team:
		doFire(mcha1)
	if mcha2 != null && mcha2.team != team:
		doFire(mcha2)

	awakenProcess += 1
	if awakenProcess >= 100 and not isAwaken and lv == 4 and team == 1:
		call("awaken")

func doFire(cha):
	cha.addBuff(buffUtil.b_shaoZhuo_r.new(8))
	cha.addBuff(buffUtil.b_shaoShi.new(8, self))
	azurHurtChara(cha, getSkillEffect("浅水重炮舰"), Chara.HurtType.PHY, Chara.AtkType.SKILL, "浅水重炮舰", true)

func _onBattleStart():
	._onBattleStart()
	addBuff(buffUtil.b_sniper.new())
	yield(reTimer(0.45),"timeout")
	fire(aiCha)

func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "浅水重炮舰":
		return att.atk * 3
	elif name == "弹幕·黑暗界":
		return att.atk * 0.7
	elif name == "光能主炮":
		return att.atk * 5