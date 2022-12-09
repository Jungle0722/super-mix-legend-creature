extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「驱逐」绫波"   #角色的名称
	attCoe.atkRan = 5#攻击距离
	attCoe.maxHp = 3#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 2     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 4  #魔法攻击（每点代表13.7）
	attCoe.def = 1     #物理防御（每点代表15）
	attCoe.mgiDef = 1#魔法防御（每点代表16.6）
	lv = 1             #等级的设置
	atkEff = "atk_dao" #攻击时的特效
	evos = ["cazurlineA_1","cazurlineA_2","cazurlineA_3","cazurlineA_4","cazurlineA_5","cazurlineA_6"]
	addSkill("每{cd}秒发射一枚鱼雷对目标造成[法强*2]({damage})的可暴击魔法伤害，并附加5层[烧蚀]", "重型鱼雷", "zxyl", 5)
	if id == "cazurlineA":
		addSkillTxt("[color=#C0C0C0]连续15回合不阵亡，则进化为特殊形态的绫波！当前进度：0/15")

	type = "dd"
	setGunAndArmor("小型","轻型")
	prefer = "ap"
	setCamp("重樱")

func _onDeath(atkInfo):
	._onDeath(atkInfo)
	level = 1

func _onBattleEnd():
	._onBattleEnd()
	if id == "cazurlineA":
		level += 1
		skillStrs[skillStrs.size() - 1] = "[color=#C0C0C0]连续15回合不阵亡，则进化为特殊形态的绫波！当前进度：%d/15"%[level-1]
		if level > 15:
			specEvoAyanami()

func specEvoAyanami():
	sys.newBaseMsg("提示", "经历一场场艰苦卓绝的战斗，绫波已今非昔比，取得了成长！")
	sys.main.player.addCha(sys.main.newChara("cex___al-ayanami"))
	deleteSelf()
	
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="zxyl" and aiCha != null:
		zxyl()

func zxyl(target = aiCha):
	if target == null:return
	createFlyEff(sprcPos, target, "sk_feiDang")
	azurHurtChara(target, getSkillEffect("重型鱼雷"), Chara.HurtType.MGI, Chara.AtkType.SKILL, "重型鱼雷", true)
	target.addBuff(buffUtil.b_shaoShi.new(5, self))

func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "重型鱼雷":
		return att.mgiAtk * 2
	elif name == "飞鱼导弹":
		return att.mgiAtk * 3
	elif name == "均衡鱼雷":
		return int(att.cri*100)
	elif name == "回音击":
		return att.mgiAtk * 2
	elif name == "重弹精通":
		return att.maxHp * 0.2
	elif name == "均衡火力":
		return att.mgiAtk * 1.4
	elif name == "六莲雷":
		return att.mgiAtk * 1.5
	elif name == "皇家标枪":
		return att.mgiAtk * 4