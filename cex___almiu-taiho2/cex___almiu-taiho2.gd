extends "../cex___almiu-taiho/cex___almiu-taiho.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「航母」大凤·μ兵装"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4
	skillStrs.pop_back()
	addSkill("战斗开始时，召唤[我方μ兵装角色数*0.5]架神风战机", "兵装解放")
	addSkillTxt(jbText)
	addSkillTxt("[color=#C0C0C0][现代化改造]-冷却速度+30%(未解锁)")
	if isInManual():
		addSkillTxt("[color=#C0C0C0][兵装解放强化]-Lv1：额外召唤1架，Lv2：神风特攻造成的伤害提高50%")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onBattleStart():
	._onBattleStart()
	var n = int(miuNum*0.5)
	if p4 > 0:
		n += 1
	for i in range(n):
		summSakura()
	if upgraded:
		addBuff(buffUtil.b_cd.new(3))