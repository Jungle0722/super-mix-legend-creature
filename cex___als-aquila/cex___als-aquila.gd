extends "../cazurlineE/cazurlineE.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」天鹰"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___als-aquila2"]
	canCopy = false
	addSkill("<先手>每{cd}秒起飞一架受自身四维加成的<舰载机>(←点击可查看说明)", "舰载机", null, null, 0)
	addSkill("每{cd}秒对当前目标直线上的所有敌人造成[四维*0.8]({damage})的可暴击物理技能伤害", "领航之箭", "aquila1", 12)
	addSkill("点击[吞噬]按钮，可以吃掉当前装备，永久吸收其40%属性(无法吸收减伤)", "无限试验")
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("铁血")
var p3 = 0.4
func castPlane():
	var summ = summPlane()
	if summ != null && not summ.isDeath:
		if lv < 4:
			var ap = att.atk + att.mgiAtk + att.def + att.mgiDef
			summ.attAdd.maxHp += ap*lv/4.0
			summ.plusHp(ap*lv)
			summ.attAdd.def += ap*lv/35.0
			summ.attAdd.mgiDef += ap*lv/35.0
			summ.attAdd.atk += ap*lv/15.0
			summ.attAdd.mgiAtk += ap*lv/15.0
		else:
			summ.attAdd.atkR -= 0.35
			summ.attAdd.defR -= 0.25
			summ.fuseAttEx(attEx)

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="aquila1":
		aquila1()

func aquila1():
	var eff:Eff = newEff("sk_feiZhan",sprcPos)
	eff._initFlyPos(position + (aiCha.position - position).normalized() * 1000, 800)
	eff.connect("onInCell",self,"effInCell")

func effInCell(cell):
	var cha = matCha(cell)
	if cha == null:
		cha = matCha(cell + Vector2(0, 1))
	if cha != null && cha.team != team :
		var dmg = getSkillEffect("领航之箭")
		azurHurtChara(cha, dmg, Chara.HurtType.PHY, Chara.AtkType.SKILL, "领航之箭", true)

func eatItem():
	var index = items.size() - 1
	while index >= 0:
		var item = items[index]
		updateTmpAtt("maxHp", item.att.maxHp*p3, false)
		updateTmpAtt("maxHpL", item.att.maxHpL*p3, false)
		updateTmpAtt("atk", item.att.atk*p3, false)
		updateTmpAtt("atkL", item.att.atkL*p3, false)
		updateTmpAtt("mgiAtk", item.att.mgiAtk*p3, false)
		updateTmpAtt("mgiAtkL", item.att.mgiAtkL*p3, false)
		updateTmpAtt("atkRan", item.att.atkRan*p3, false)
		updateTmpAtt("def", item.att.def*p3, false)
		updateTmpAtt("mgiDef", item.att.mgiDef*p3, false)
		updateTmpAtt("defL", item.att.defL*p3, false)
		updateTmpAtt("mgiDefL", item.att.mgiDefL*p3, false)
		updateTmpAtt("pen", item.att.pen*p3, false)
		updateTmpAtt("mgiPen", item.att.mgiPen*p3, false)
		updateTmpAtt("penL", item.att.penL*p3, false)
		updateTmpAtt("mgiPenL", item.att.mgiPenL*p3, false)
		updateTmpAtt("cri", item.att.cri*p3, false)
		updateTmpAtt("criR", item.att.criR*p3, false)
		updateTmpAtt("suck", item.att.suck*p3, false)
		updateTmpAtt("mgiSuck", item.att.mgiSuck*p3, false)
		updateTmpAtt("reHp", item.att.reHp*p3, false)
		updateTmpAtt("spd", item.att.spd*p3, false)
		updateTmpAtt("dod", item.att.dod*p3, false)
		var cdp = 1
		if att.cd > 1:cdp = 0.5
		if att.cd > 2:cdp = 0.25
		if att.cd > 3:cdp = 0.1
		if item.att.cd > 4:cdp = 0.1
		updateTmpAtt("cd", item.att.cd*p3*cdp, false)
		updateTmpAtt("atkR", item.att.atkR*p3*0.5, false)
		sys.main.player.delItem(item)
		index -= 1
		upAtt()