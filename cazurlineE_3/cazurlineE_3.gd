extends "../cazurlineE/cazurlineE.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」飞龙"   #角色的名称
	attCoe.mgiAtk += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.maxHp += 1
	lv = 2             #等级的设置
	evos = ["cazurlineE_3_1","cazurlineE_3_2"]
	addSkill("战斗开始时，分别对物攻、魔攻最高的敌人造成[法强*3]({damage})的真实伤害，并附带10秒<虚弱>", "先手必胜")

	setCamp("重樱")

var jbFlag = 1
func _onBattleStart():
	._onBattleStart()
	var p1 = 3
	var p2 = 10
	var enemy = getAllChas(1)
	if team == 1:
		enemy.sort_custom(self,"sortByAtkDesc")
	else:
		enemy.sort_custom(self,"sortByMaxHpDesc")
	
	for i in range(jbFlag):
		if i >= enemy.size():break
		createCustEff(enemy[i].position, "eff/thunder", 15, false, 1.3, Vector2(0, -20))
		azurHurtChara(enemy[i], att.mgiAtk*p1, Chara.HurtType.REAL, Chara.AtkType.SKILL, "先手必胜")
		enemy[i].addBuff(utils.buffs.b_weak.new(p2))
	
	enemy = getAllChas(1)
	if team == 1:
		enemy.sort_custom(self,"sortByAtkDesc")
	else:
		enemy.sort_custom(self,"sortByMaxHpDesc")
	for i in range(jbFlag):
		if i >= enemy.size():break
		createCustEff(enemy[i].position, "eff/thunder", 15, false, 1.3, Vector2(0, -20))
		azurHurtChara(enemy[i], att.mgiAtk*p1, Chara.HurtType.REAL, Chara.AtkType.SKILL, "先手必胜")
		enemy[i].addBuff(utils.buffs.b_weak.new(p2))