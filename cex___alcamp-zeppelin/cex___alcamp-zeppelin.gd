extends "../cazurlineE/cazurlineE.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」齐柏林伯爵"   #角色的名称
	attCoe.maxHp += 5   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 4     #物理防御（每点代表15）
	attCoe.mgiDef += 3  #魔法防御（每点代表16.6）
	attCoe.atkRan = 2
	lv = 3             #等级的设置
	evos = ["cex___alcamp-zeppelin2"]
	canCopy = false
	ename = "qibolin"
	addSkill("<先手>每{cd}秒起飞一架受自身护甲加成的<舰载机>(←点击可查看说明)", "舰载机", null, null, 0)
	addSkill("每秒对周围3格的敌人造成[本回合已受伤害量]的物理技能伤害，每造成6次技能伤害，\n				恢复自身20%血量", "短兵相接")
	addSkill("护甲能够额外减免所有类型的伤害", "合金装甲")
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("铁血")

func _onBattleEnd():
	._onBattleEnd()
	hurtNum1 = 0
	skillNum1 = 0
func castPlane():
	var summ = summPlane()
	if summ != null && not summ.isDeath and team == 1:
		var ap = float(att.def)
		summ.attAdd.maxHp += ap*lv*1.2
		summ.plusHp(ap*lv)
		summ.attAdd.def += ap*lv/8.0
		summ.attAdd.mgiDef += ap*lv/8.0
		summ.attAdd.penL += min(ap*lv/10000.0, 0.4)
		summ.attAdd.dod += min(ap*lv/10000.0, 0.4)
		summ.attAdd.reHp += min(ap*lv/6000.0, 1)

		if lv == 4:
			summ.additionSkill = skillPool.getSkill(57, 2)
			summ.additionSkill.setCha(summ)

var p3 = 0.2
var hurtNum1 = 0
var skillNum1 = 0
func _upS():
	._upS()
	for i in getCellChas(cell, 3, 1):
		azurHurtChara(i, hurtNum1, Chara.HurtType.PHY, Chara.AtkType.SKILL, "短兵相接")
	
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.SKILL:
		skillNum1 += 1
	if skillNum1 >= 6:
		skillNum1 = 0
		healCha(self, att.maxHp*p3)

func _onHurtEnd(atkInfo):
	._onHurtEnd(atkInfo)
	hurtNum1 += atkInfo.hurtVal

func _onHurt(atkInfo):
	._onHurt(atkInfo)	
	var p = att.def / (att.def + 100.0) * 0.35
	atkInfo.hurtVal *= (1 - p)