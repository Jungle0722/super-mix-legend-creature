extends "../cazurlineF/cazurlineF.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「辅助」33"   #角色的名称
	attCoe.maxHp += 2
	lv = 3             #等级的设置
	evos = ["cazurlineF_4_2_1"]
	attAdd.maxHpL += 0.2

	addSkill("战斗开始时，赋予全体友军[200+血上限*0.3]({damage})的护盾值", "护盾发生器3")
	addSkill("<亡语>血上限提高20%，死亡时，赋予全体友军[血上限*0.3]({damage})的护盾", "护盾释放")

	autoGetSkill()
	setCamp("其他")
var p3 = 0.3
func _onBattleStart():
	._onBattleStart()
	for i in getAllChas(2):
		if not i.has_method("changeShield"):continue
		i.changeShield(200 + att.maxHp*0.3)

func deathWord():
	.deathWord()
	for i in getAllChas(2):
		if not i.has_method("changeShield"):continue
		i.changeShield(200 + att.maxHp*p3*0.5)