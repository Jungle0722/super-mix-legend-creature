extends "../cex___alr-georgia/cex___alr-georgia.gd"
func _info():
	pass
func _connect():
	._connect()
var baseId = ""
func _extInit():
	._extInit()
	chaName = "「战列」佐治亚"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置

	addSkillTxt("[color=#C0C0C0]可进行强化，每次强化提高：血上限150，攻击100，爆伤3%，强化5次/10次时分别获得大幅提升")
	addSkillTxt("[color=#C0C0C0][现代化改造]-装甲碾压伤害系数+1(未解锁)")
	autoGetSkill()
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

	if isAwaken:
		awaken()

func awaken(msg = true):
	isAwaken = true
	addSkillTxt("[color=#C0C0C0][心智觉醒]-装甲碾压每次附带4层<漏水><流血>")	

func upgrade():
	p4 = 3
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func strengthen():
	level += 1
	updateTmpAtt("atk", 100)
	updateTmpAtt("maxHp", 150)
	updateTmpAtt("criR", 0.03)
	if level == 6 or level == 11:
		updateTmpAtt("atkL", 0.15)
		updateTmpAtt("mgiAtkL", 0.15)
		updateTmpAtt("maxHpL", 0.2)
		if level == 11:
			awaken()


