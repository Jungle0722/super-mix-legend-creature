extends "../cex___al-independence/cex___al-independence.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」独立·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 2
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("战斗开始时，赋予我方舰娘3层天之骑士效果：受到致命伤害时，恢复20%血量，改由我方舰载机承担，\n并消耗一层该效果", "天之骑士")
	addSkillTxt("[color=#C0C0C0][现代化改造]-空域辅助触发治疗时，10%概率为目标赋予1层天之骑士效果(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onBattleStart():
	._onBattleStart()
	for i in getAllChas(2):
		var bf = i.hasBuff("b_independence")
		if bf != null:
			bf.num += 3
		else:
			i.addBuff(buffUtil.b_independence.new(3, self))


