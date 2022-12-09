extends "../azurline_ctrl/carrier.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「航母」飞龙·Meta·Lv%d"%level   #角色的名称
	attCoe.atkRan = 4#攻击距离
	attCoe.maxHp = 5#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 5     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 3  #魔法攻击（每点代表13.7）
	attCoe.def = 4     #物理防御（每点代表15）
	attCoe.mgiDef = 4#魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	atkEff = "atk_dang" #攻击时的特效
	setGunAndArmor("小型","重型")
	setCamp("塞壬")
	lv = 3             #等级的设置
	evos = ["cex___al-feilong2"]

	addSkill("每{cd}秒起飞一架受自身双攻加成的<舰载机>(←点击可查看说明)", "舰载机", "castPlane", 12)
	addSkill("普攻后，指挥我方所有的轰炸机对目标发起普攻(内置冷却1秒)", "烬火之刃")
	addSkill("对同一个敌人造成的普攻伤害，每次提高100%(上限1000%)", "光暗花札")
	autoGetSkill()
	if id == "cex___al-feilong":
		addSkillTxt("[color=#C0C0C0]参加18场战斗后，将进化为传奇单位[/color]")
	type = "siren"
	canCopy = false
	ename = "heifeilong"
	
func levelUp():
	.levelUp()
	updateAtt()

func updateAtt():
	updateTmpAtt("maxHp", 100, false)
	updateTmpAtt("atk", 10, false)
	updateTmpAtt("mgiAtk", 10, false)
	updateTmpAtt("def", 10, false)
	updateTmpAtt("mgiDef", 10, false)
	updateTmpAtt("spd", 0.05, false)
	if level == 20 and gSiren.sirenAwaken:
		call("awaken")
		updateTmpAtt("maxHp", 1000, false)
		updateTmpAtt("atk", 100, false)
		updateTmpAtt("mgiAtk", 100, false)
		updateTmpAtt("def", 100, false)
		updateTmpAtt("mgiDef", 100, false)
		updateTmpAtt("spd", 0.4, false)
	upAtt()

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="castPlane":
		self.castPlane()

func castPlane():
	var summ = summPlane()
	if lv == 1:return summ
	if summ != null && not summ.isDeath and team == 1:
		var ap = float(att.mgiAtk + att.atk)
		summ.attAdd.maxHp += (ap/6.0)*lv
		summ.plusHp((ap/6.0)*lv)
		summ.attAdd.def = (ap/7.0)*lv
		summ.attAdd.mgiDef = (ap/7.0)*lv
		summ.attAdd.atk = (ap/5.5)*lv
		summ.attAdd.mgiAtk = (ap/5.5)*lv
		summ.upAtt()
	return summ	

var skFlag = true
func _upS():
	._upS()
	skFlag = true

func _onNormalAtk(cha):
	._onNormalAtk(cha)
	if skFlag:
		skFlag = false
		for i in getAllChas(2):
			if i.get("prefer") == "cas" and not cha.isDeath:
				i.normalAtkChara(cha)
var skRecord = {}
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		var skNum = utils.dicGet(skRecord, atkInfo.hitCha, 0)
		atkInfo.factor += skNum
		if skNum < 10:
			utils.dicPlus(skRecord, atkInfo.hitCha, 1)
		elif isAwaken:
			azurHurtChara(atkInfo.hitCha, att.atk*10, Chara.HurtType.PHY, Chara.AtkType.EFF, "心智觉醒")

func _onBattleEnd():
	._onBattleEnd()
	skRecord.clear()



