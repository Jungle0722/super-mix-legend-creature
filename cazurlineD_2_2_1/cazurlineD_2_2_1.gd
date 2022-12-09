extends "../cazurlineD_2_2/cazurlineD_2_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」让巴尔·誓约"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 3     #攻击力（每点代表8.5））
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("每{cd}秒对当前目标发起5次普攻", "最后的炮火", "lastFire", 8)

	addSkillTxt("[color=#C0C0C0][现代化改造]-海盗之魂触发概率翻倍(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="lastFire":
		lastFire()

func lastFire():
	utils.createSkillTextEff("最后的炮火", position)
	for i in range(5):
		yield(reTimer(0.15),"timeout")
		if aiCha == null:
			yield(reTimer(0.05),"timeout")
		.normalAtkChara(aiCha)

func upgrade():
	p3 = 2
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")