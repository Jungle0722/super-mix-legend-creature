extends "../cex___alr-chester/cex___alr-chester.gd"
func _info():
	pass
var baseId = ""
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「重巡」柴郡"
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1     #物理防御（每点代表15）
	lv = 4
	addSkillTxt("[color=#C0C0C0]可进行强化，每次强化提高：血上限250，攻击150，强化5次/10次时分别获得大幅提升")
	addSkillTxt("[color=#C0C0C0][现代化改造]-PowerUp无需触发条件(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()

func awaken(msg = true):
	isAwaken = true
	addSkillTxt("[color=#C0C0C0][心智觉醒]-友军每使用10次技能，柴郡对当前目标发起2次普攻(内置冷却4秒)")

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	
func strengthen():
	level += 1
	updateTmpAtt("maxHp", 250)
	updateTmpAtt("atk", 150)
	if level == 6 or level == 11:
		updateTmpAtt("atkL", 0.15)
		updateTmpAtt("mgiAtkL", 0.15)
		updateTmpAtt("maxHpL", 0.2)
		if level == 11:
			awaken()

