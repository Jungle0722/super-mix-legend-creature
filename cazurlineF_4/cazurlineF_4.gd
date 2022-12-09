extends "../cazurlineF/cazurlineF.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「辅助」金布里"   #角色的名称
	attCoe.mgiAtk += 1  #魔法攻击（每点代表13.7）
	attCoe.maxHp += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 2             #等级的设置
	evos = ["cazurlineF_4_1","cazurlineF_4_2"]
	addSkill("战斗开始时，赋予全体友军[200+法强*1.2]({damage})的护盾值", "护盾发生器")

	setCamp("其他")
	itemEvoCha = "cex___al-purin"

func _onBattleStart():
	._onBattleStart()
	for i in getAllChas(2):
		if not i.has_method("changeShield"):continue
		i.changeShield(200 + att.mgiAtk*1.2)