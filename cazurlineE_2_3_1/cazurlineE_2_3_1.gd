extends "../cazurlineE_2_3/cazurlineE_2_3.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」英仙座·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 2
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("每{cd}秒一次性发动10次群星坠落，每次提高50%伤害", "天幕破碎", "e231", 12)

	addSkillTxt("[color=#C0C0C0][现代化改造]-群星坠落额外附带5层<烧灼>(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="e231":
		e231()

func e231():
	p3 = 1
	for i in range(10):
		qxzl()
		p3 += 0.5
		yield(reTimer(0.1),"timeout")	
	p3 = 1	

func _onBattleEnd():
	._onBattleEnd()
	p3 = 1