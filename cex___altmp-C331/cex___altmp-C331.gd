extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
var summoner
func _extInit():
	._extInit()
	chaName = "「特殊」塔林·分身"   #角色的名称
	attCoe.atkRan = 1#攻击距离
	attCoe.maxHp = 5#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 5     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 5  #魔法攻击（每点代表13.7）
	attCoe.def = 5     #物理防御（每点代表15）
	attCoe.mgiDef = 5#魔法防御（每点代表16.6）
	atkEff = "atk_dao" #攻击时的特效
	isSumm = true
	lv = 3             #等级的设置
var enable = false
func deathWord():
	.deathWord()
	if not enable:return
	for i in getCellChas(cell, 2, 1):
		var dmg = min(i.att.maxHp * 1, (att.maxHp + i.att.maxHp) * 0.4)
		azurHurtChara(i, dmg, Chara.HurtType.PHY, Chara.AtkType.SKILL, "核弹运输")