extends "../cazurlineA/cazurlineA.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」春月"   #角色的名称
	attCoe.mgiAtk += 1  #魔法攻击（每点代表13.7）
	attCoe.atk += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 2             #等级的设置
	evos = ["cazurlineA_5_1", "cazurlineA_5_2"]
	addSkill("普攻附带[法强*1.4]({damage})的可暴击技能伤害", "均衡火力")
	setCamp("重樱")
	
var p2 = 1
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		var dmg = getSkillEffect("均衡火力") * p2
		azurHurtChara(atkInfo.hitCha, dmg, Chara.HurtType.MGI, Chara.AtkType.SKILL, "均衡火力", true)
		if id == "cazurlineA_5_1_1":
			for i in getCellChas(atkInfo.hitCha.cell, 2, 1):
				azurHurtChara(i, min(i.att.maxHp*1, dmg), Chara.HurtType.MGI, Chara.AtkType.SKILL, "均衡火力", true)