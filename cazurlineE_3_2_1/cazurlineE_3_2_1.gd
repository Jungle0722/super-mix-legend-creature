extends "../cazurlineE_3_2/cazurlineE_3_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」赤城·幼"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）attCoe.mgiDef += 1
	attCoe.mgiAtk += 2
	lv = 4             #等级的设置
	addSkill("每{cd}秒对一条直线上的敌人造成[法强*3]({damage})的魔法伤害，并眩晕1秒", "恶作剧", "qx", 8, skillStrs.size()-1)
	if id == "cazurlineE_3_2_1":
		addSkillTxt("[color=#C0C0C0][羁绊·一航战]-我方场上存在加贺时，先手必胜额外分别对两名敌人生效[/color]")
		addSkillTxt("[color=#C0C0C0][现代化改造]-恶作剧对全场敌人施放，不再附带眩晕(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="qx":
		qx()
		if self.id == "cex___almiu-akagi2" and upgraded:
			for i in range(int(miuNum*0.5)):
				yield(reTimer(0.1),"timeout")
				qx()

func qx():
	if not upgraded or id == "cex___almiu-akagi2":
		var eff:Eff = newEff("sk_feiZhan",sprcPos)
		eff._initFlyPos(position + (aiCha.position - position).normalized() * 1000, 800)
		eff.connect("onInCell",self,"effInCell")
	else:
		for i in getAllChas(1):
			azurHurtChara(i, min(i.att.maxHp*1.2, getSkillEffect("恶作剧")), Chara.HurtType.MGI, Chara.AtkType.SKILL, "恶作剧")

func effInCell(cell):
	var cha = matCha(cell)
	if cha == null:
		cha = matCha(cell + Vector2(0, 1))
	if cha != null && cha.team != team :
		var dmg = getSkillEffect("恶作剧")
		azurHurtChara(cha, dmg, Chara.HurtType.MGI, Chara.AtkType.SKILL, "恶作剧")
		var bf = cha.hasBuff("b_xuanYun")
		if bf == null:
			cha.addBuff(buffUtil.b_xuanYun.new(1))
		else:
			bf.life += 0.1

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
