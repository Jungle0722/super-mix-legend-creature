extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「辅助」紫布里"   #角色的名称
	attCoe.atkRan = 3#攻击距离
	attCoe.maxHp = 3#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 2     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 4  #魔法攻击（每点代表13.7）
	attCoe.def = 1     #物理防御（每点代表15）
	attCoe.mgiDef = 1#魔法防御（每点代表16.6）
	lv = 1             #等级的设置
	atkEff = "atk_dang" #攻击时的特效
	evos = ["cazurlineF_1","cazurlineF_2","cazurlineF_3","cazurlineF_4","cazurlineF_5"]
	addSkill("战斗结束时获得6金币", "被迫营业")

	type = "sup"
	setGunAndArmor("小型","轻型")
	prefer = "sup"
	setCamp("其他")

func _onBattleEnd():
	._onBattleEnd()
	if team == 1:
		sys.main.player.plusGold(6)

func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "随缘治疗":
		return att.mgiAtk * 2
	elif name == "后勤维修":
		return att.mgiAtk * 3
	elif name == "护盾发生器":
		return att.mgiAtk * 1.2 + 200
	elif name == "护盾充能":
		return att.mgiAtk * 1.2 + 200
	elif name == "护盾发生器3":
		return att.maxHp * 0.3 + 200
	elif name == "护盾释放":
		return att.maxHp * 0.3
	elif name == "保护对手":
		return att.mgiAtk * 3 * 0.01
	elif name == "痛击队友":
		return att.mgiAtk * 2 * 0.01
	elif name == "撒币战术":
		return att.mgiAtk * 4
		