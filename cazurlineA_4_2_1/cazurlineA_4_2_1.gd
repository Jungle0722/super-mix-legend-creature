extends "../cazurlineA_4_2/cazurlineA_4_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」Z46·改"   #角色的名称
	attCoe.maxHp += 4   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 1
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("装备[超重弹]时，回音击额外附带[血上限*0.1]({damage})的魔法伤害", "重弹精通")
	addSkillTxt("[color=#C0C0C0][现代化改造]-回音击伤害提高35%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""

func _onBattleEnd():
	._onBattleEnd()
	czdFlag = false

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	p3 = 2.7