extends "../cazurlineF_4_2/cazurlineF_4_2.gd"
func _info():
	pass
func _connect():
	._connect()
var allCell = []
func _extInit():
	._extInit()
	chaName = "「辅助」33·Up"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	lv = 4             #等级的设置
	addSkill("<亡语>四维提高15%，死亡时，弱驱散敌方单位的全部护盾和正面效果，并造成驱散量的魔法伤害", "EMP")

	addSkillTxt("[color=#C0C0C0][现代化改造]-护盾释放亡语效果翻倍(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	attAdd.atkL += 0.15
	attAdd.mgiAtkL += 0.15
	attAdd.defL += 0.15
	attAdd.mgiDefL += 0.15

func upgrade():
	p3 = 0.6
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""

func deathWord():
	.deathWord()
	for i in getAllChas(1):
		var num = 0
		if i.has_method("changeShield") and i.shield > 0:
			if team == 1:
				num += i.shield * 1
			else:
				num += i.shield * 0.3
			i.changeShield(-i.shield)
		for j in i.buffs:
			if not j.isNegetive && j.get("type") != config.EQUITYPE_EQUI && j.get("dispel") != 2 and j.get("dispel") != 3:
				j.isDel = true
				if team == 1:
					num += (100 * difficult.difficult)
				else:
					num += 100
		if num > 0:
			azurHurtChara(i, min(i.att.maxHp*1.2, num), Chara.HurtType.MGI, Chara.AtkType.EFF, "EMP")