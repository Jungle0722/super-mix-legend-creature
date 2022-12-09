extends "../cazurlineD_6/cazurlineD_6.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」苏维埃贝拉罗斯"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1
	attCoe.def += 1
	lv = 3             #等级的设置
	evos = ["cazurlineD_6_2_1"]
	addSkill("每{cd}秒对攻击最高的敌人及其周围3格内的敌方单位赋予10层<霜冻>", "陨落冰耀", "fallenIce", 10)
	autoGetSkill()
	setCamp("北方联合")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="fallenIce":
		fallenIce()

func fallenIce():
	var cha = getFirstCha(1, "sortByAtkDesc", true)
	if cha == null:return
	for i in getCellChas(cha.cell, 3, 1):
		i.addBuff(buffUtil.b_freeze.new(10))
		if upgraded:
			var bf = i.hasBuff("b_freeze")
			if bf != null and bf.life >= 18:
				if team == 1:
					azurHurtChara(i, maxHp(i)*0.4, Chara.HurtType.REAL, Chara.AtkType.SKILL, "陨落冰耀")
				else:
					azurHurtChara(i, maxHp(i)*1, Chara.HurtType.PHY, Chara.AtkType.SKILL, "陨落冰耀")