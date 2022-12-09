extends "../cazurlineF_1/cazurlineF_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「辅助」U37"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___als-u372"]
	addSkill("本回合，每次造成技能伤害均使自己之后造成的技能伤害提高10%(上限200%)", "越战越勇")

	autoGetSkill()
	supportSpecEvo = 2
	canCopy = false
	setCamp("铁血")

func _onBattleEnd():
	._onBattleEnd()
	p3 = 0

var p3 = 0
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.SKILL:
		atkInfo.factor += p3
		if p3 <= 3:
			p3 += 0.1
		