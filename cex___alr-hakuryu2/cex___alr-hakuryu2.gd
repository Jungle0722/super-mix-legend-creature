extends "../cex___alr-hakuryu/cex___alr-hakuryu.gd"
func _info():
	pass
var baseId = ""
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「航母」白龙"
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1     #物理防御（每点代表15）
	lv = 4
	addSkill("若装备鱼雷机，则使其学会天雷罪灭，但伤害减半", "白龙云影")

	addSkillTxt("[color=#C0C0C0]可进行强化，每次强化提高：血上限200，法强100，强化5次/10次时分别获得大幅提升")
	addSkillTxt("[color=#C0C0C0][现代化改造]-苍天对罪不悔改之人不再仁慈，天雷罪灭对同一个目标造成的伤害每次递增50%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

	if isAwaken:
		awaken()

func awaken(msg = true):
	isAwaken = true
	addSkillTxt("[color=#C0C0C0][心智觉醒]-天雷罪灭对同一个目标内置冷却-3秒，且开局预充能5秒")

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func castPlane():
	var summ = .castPlane()
	if summ != null and not summ.isDeath:
		summ.additionSkill = skillPool.getSkill(57, 2)
		summ.additionSkill.setCha(summ)

func _onBattleStart():
	._onBattleStart()
	var sk = getSkill("tianleizm")
	sk.nowTime += 5

func strengthen():
	level += 1
	updateTmpAtt("maxHp", 200)
	updateTmpAtt("mgiAtk", 100)
	if level == 6 or level == 11:
		updateTmpAtt("atkL", 0.05)
		updateTmpAtt("mgiAtkL", 0.05)
		if level == 11:
			awaken()

