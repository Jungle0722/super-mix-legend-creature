extends "../cex___alcamp-sandiego/cex___alcamp-sandiego.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」圣地亚哥·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 3
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("<先手>每{cd}秒对所有敌人造成[攻击*3]({damage})的可暴击技能伤害", "战斗之星", "sk_sandiego", 8)

	addSkillTxt("[color=#C0C0C0][现代化改造]-战斗之星伤害提高50%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var p4 = 3		
func upgrade():
	p4 = 4.5
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "sk_sandiego":
		battleStar()

func _onBattleStart():
	._onBattleStart()
	battleStar()

func battleStar():
	for i in getAllChas(1):
		azurHurtChara(i, att.atk*p4, Chara.HurtType.PHY, Chara.AtkType.SKILL, "战斗之星")