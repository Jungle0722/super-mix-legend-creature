extends "../cex___al-weaveDream/cex___al-weaveDream.gd"
func _info():
	pass
func _connect():
	._connect()
var baseId = ""
func _extInit():
	._extInit()
	chaName = "「塞壬」织梦者·Lv%d"%level   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2	 #攻击力（每点代表8.5）
	attCoe.mgiAtk += 2  #魔法攻击（每点代表13.7）
	attCoe.def += 2	#物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	
	addSkill("所有敌人技能冷却速度降低20%，每{cd}秒，延长所有敌人的技能4秒冷却时间", "梦想封印", "mxfy", 10)
	addSkill("受到的物理伤害降低50%，额外受到20%的魔法伤害", "虚无存在")
	addSkillTxt("[color=#C0C0C0]每次参加战斗即可积累经验，以提升战斗等级，升级可全方位提升实力[/color]")
	addSkillTxt("[color=#C0C0C0][现代化改造]-编制噩梦伤害提高100%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()
		
func awaken(msg = true):
	isAwaken = true
	addSkillTxt("[color=#C0C0C0][心智觉醒]-梦境投影复制的单位将获得当前难度加成")

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	p1 = 4