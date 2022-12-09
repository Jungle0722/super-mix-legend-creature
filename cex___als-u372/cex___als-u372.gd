extends "../cex___als-u37/cex___als-u37.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「辅助」U37·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("每{cd}秒沿直线发射一枚特殊的鱼雷，路径上每接触一名敌人，均造成[法强*4]({damage})的伤害，并向以该敌人\n				为中心向随机另1名敌人弹射", "西进之戟", "u37_xjzj", 8)
	addSkillTxt("[color=#C0C0C0][羁绊·水下战队]-场上每有一艘其他不同型号的潜艇舰娘，提高20%冷却、20%法术穿透")
	addSkillTxt("[color=#C0C0C0][现代化改造]-西进之戟额外弹射1个目标(未解锁)")
	addSkillTxt("[color=#C0C0C0]U37、U47、大青花鱼并肩战斗，终将觉醒...")
	if upgraded:
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()
func upgrade():
	p4 = 2
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
var baseId = ""

func awaken(msg = true):
	chaName = "「辅助」U37·觉醒"
	p42 = 2
	addSkill("西进之戟伤害提高100%", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "U37已经获得了心智觉醒！")
	isAwaken = true
#西进之戟弹射数量
var p4 = 1
#西进之戟额外伤害
var p42 = 1
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "u37_xjzj":
		u37_xjzj()

func u37_xjzj():
	utils.createSkillTextEff("西进之戟", position)
	var eff1:Eff = sys.newEff("animEff", sys.main.map.map_to_world(cell))
	eff1.setImgs(direc + "eff/thunderFly", 9, true)
	eff1._initFlyPos(position + (aiCha.position - position).normalized() * 1000, 250)
	eff1.normalSpr.position=Vector2(0, -30)
	eff1.connect("onInCell",self,"effInCell2")
			
func effInCell2(cell):
	var cha = matCha(cell)
	if cha == null:
		cha = matCha(cell + Vector2(0, 1))
	if cha != null && cha.team != team:
		azurHurtChara(cha, getSkillEffect("西进之戟")*p42, Chara.HurtType.MGI, Chara.AtkType.SKILL, "西进之戟")
		var chas = getAllChas(1)
		chas.erase(cha)
		chas.shuffle()
		for i in range(p4):
			if i >= chas.size():break
			createFlyEff(cha.sprcPos, chas[i], "sk_4_1_2")
			azurHurtChara(chas[i], getSkillEffect("西进之戟")*p42, Chara.HurtType.MGI, Chara.AtkType.SKILL, "西进之戟")

func _onBattleStart():
	._onBattleStart()
	var types = utils.checkSubMarineTypes(self)
	types.erase("U37")
	if types.size() > 0:
		addBuff(buffUtil.b_jb_ss.new(types.size()))
	if types.size() >= 3:
		awakenProcess += 1
		if awakenProcess >= 21 and not isAwaken:
			call("awaken")

		