extends "../cazurlineF_5_1/cazurlineF_5_1.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「辅助」绊爱·Lv4"   #角色的名称
	attCoe.mgiAtk += 2  #魔法攻击（每点代表13.7）
	attCoe.maxHp += 2
	attCoe.def += 2
	attCoe.mgiDef += 2
	lv = 4             #等级的设置
	addSkill("当每回合金币收益达到上限时，立即对所有没被眩晕的敌人造成4秒眩晕", "不再划水")

	addSkillTxt("[color=#C0C0C0][现代化改造]-保护对手、痛击队友金币转化系数翻倍(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	p2 = 0.02
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""


		