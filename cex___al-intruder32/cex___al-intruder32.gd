extends "../cex___al-intruder3/cex___al-intruder3.gd"
func _info():
	pass
var baseId = ""
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」侵扰者Ⅲ型·Lv%d"%level    #角色的名称
	attCoe.maxHp += 1#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.mgiAtk += 1  #魔法攻击（每点代表13.7）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1#魔法防御（每点代表16.6）
	lv = 4
	addSkill("每{cd}秒赋予所有敌人8层<致盲>", "强力干扰", "qlgr", 5)
	addSkillTxt("[color=#C0C0C0]每次参加战斗即可积累经验，以提升战斗等级，升级可全方位提升实力[/color]")
	addSkillTxt("[color=#C0C0C0][现代化改造]-强袭额外附带5层<霜冻><流血>(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()
		
func awaken(msg = true):
	isAwaken = true
	addSkillTxt("[color=#C0C0C0][心智觉醒]-强力干扰额外附带2层<暴露>")

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")