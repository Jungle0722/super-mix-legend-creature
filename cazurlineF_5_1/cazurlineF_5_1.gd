extends "../cazurlineF_5/cazurlineF_5.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「辅助」绊爱·Lv3"   #角色的名称
	attCoe.mgiAtk += 1  #魔法攻击（每点代表13.7）
	attCoe.maxHp += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 3             #等级的设置
	evos = ["cazurlineF_5_1_1"]
	addSkill("每{cd}秒治疗随机敌人[法强*3]的血量，并获得[治疗量*1%]({damage})的金币(一回合上限60金)", "保护对手", "sk_banai", 5)

	autoGetSkill()


