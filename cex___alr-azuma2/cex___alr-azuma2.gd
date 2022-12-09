extends "../cex___alr-azuma/cex___alr-azuma.gd"
func _info():
	pass
var baseId = ""
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「重巡」吾妻"
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2     #物理防御（每点代表15）
	lv = 4
	addSkillTxt("[color=#C0C0C0]可进行强化，每次强化提高：血上限300，攻击150，暴击爆伤10%，强化5次/10次时分别获得大幅提升")
	addSkillTxt("[color=#C0C0C0][现代化改造]-怒火连峰触发阈值变为10次(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()

func awaken(msg = true):
	isAwaken = true
	addSkillTxt("[color=#C0C0C0][心智觉醒]-战斗本能使用后，保留60%累计值")

func upgrade():
	p4 = 10
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func strengthen():
	level += 1
	updateTmpAtt("maxHp", 300)
	updateTmpAtt("atk", 150)
	updateTmpAtt("cri", 0.1)
	updateTmpAtt("criR", 0.1)
	if level == 6 or level == 11:
		updateTmpAtt("atkL", 0.15)
		updateTmpAtt("mgiAtkL", 0.15)
		updateTmpAtt("maxHpL", 0.2)
		updateTmpAtt("spd", 0.2)
		if level == 11:
			awaken()