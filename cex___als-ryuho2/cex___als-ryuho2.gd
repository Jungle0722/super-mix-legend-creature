extends "../cex___als-ryuho/cex___als-ryuho.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」龙凤·花嫁"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("每{cd}秒对龙卷风周围2格的敌人造成[攻击*2]({damage})的技能伤害", "樱绽凤华", "ryuho2", 10)
	addSkillTxt("[color=#C0C0C0][现代化改造]-龙卷风伤害提高30%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="ryuho2":
		ryuho2()

func ryuho2():
	for i in getCellChas(effCell, 2, 1):
		azurHurtChara(i, att.atk*2, Chara.HurtType.PHY, Chara.AtkType.SKILL, "樱绽凤华")
