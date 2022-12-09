extends "../cazurlineA_1_3/cazurlineA_1_3.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」猫音·改"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 3
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	attCoe.def += 1
	lv = 4             #等级的设置
	addSkill("每{cd}秒提高自身10%法强", "白虹", "baiHong", 8)
	addSkillTxt("[color=#C0C0C0][现代化改造]-彗星头锤伤害提高35%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="baiHong":
		baiHong()

func baiHong():
	addBuff(buffUtil.b_mgiAtkL.new(1))