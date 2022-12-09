extends "../cex___alr-kitakaze/cex___alr-kitakaze.gd"
func _info():
	pass
var baseId = ""
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「驱逐」北风"
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 2     #攻击力（每点代表8.5）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2     #物理防御（每点代表15）
	lv = 4
	addSkill("相位鱼雷将附带相位护盾抵消的所有伤害，触发后清空一半累计值，上限[法强*20]", "相位转移")
	addSkillTxt("[color=#C0C0C0]可进行强化，每次强化提高：法强/双防/血上限140，强化5次/10次时分别获得大幅提升")
	addSkillTxt("[color=#C0C0C0][现代化改造]-相位鱼雷造成的伤害可以为自己恢复[伤害量50%]的血量(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

	if isAwaken:
		awaken()

func awaken(msg = true):
	isAwaken = true
	addSkillTxt("[color=#C0C0C0][心智觉醒]-相位鱼雷伤害提高30%")

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func strengthen():
	level += 1
	updateTmpAtt("mgiAtk", 140)
	updateTmpAtt("def", 140)
	updateTmpAtt("mgiDef", 140)
	updateTmpAtt("maxHp", 140)
	if level == 6 or level == 11:
		updateTmpAtt("atkL", 0.15)
		updateTmpAtt("mgiAtkL", 0.15)
		updateTmpAtt("maxHpL", 0.2)
		updateTmpAtt("cd", 0.2)
		updateTmpAtt("spd", 0.2)
		if level == 11:
			awaken()