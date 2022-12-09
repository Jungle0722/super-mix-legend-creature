extends "../cex___alr-anchorage/cex___alr-anchorage.gd"
func _info():
	pass
var baseId = ""
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「重巡」安克雷奇"
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 2     #攻击力（每点代表8.5）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2     #物理防御（每点代表15）
	lv = 4
	addSkill("光矛照射到敌人身上有30%的几率向随机方向折射", "光矛散射")
	addSkillTxt("[color=#C0C0C0]可进行强化，每次强化提高：暴击伤害5%，法强100，强化5次/10次时分别获得大幅提升")
	addSkillTxt("[color=#C0C0C0][现代化改造]-冷却缩减将等比例提高光矛伤害(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()

func awaken(msg = true):
	isAwaken = true
	addSkillTxt("[color=#C0C0C0][心智觉醒]-若同行不存在敌方单位，则往上位移一格(若处于地图最上面，则会到最下面，若格子有人，则再往上搜索)")

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	
func strengthen():
	level += 1
	updateTmpAtt("criR", 0.05)
	updateTmpAtt("mgiAtk", 100)
	if level == 6 or level == 11:
		updateTmpAtt("atkL", 0.05)
		updateTmpAtt("mgiAtkL", 0.05)
		updateTmpAtt("maxHpL", 0.1)
		if level == 11:
			awaken()

func _upS():
	._upS()
	if isAwaken:
		var flag = true
		for i in range(10):
			var cha = matCha(Vector2(0, cell.y) + Vector2(i, 0))
			if cha != null && cha.team != team:
				flag = false
				break
		if flag:
			#需要位移
			var index = -1
			var c = cell + Vector2(0, -1)
			if c.y == -1:c.y = 5
			while matCha(c) != null and index > -5:
				index -= 1
				c = cell + Vector2(0, -1)
				if c.y == -1:c.y = 5
			if matCha(c) == null:
				setCell(c)
				
