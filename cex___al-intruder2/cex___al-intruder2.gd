extends "../cex___al-intruder/cex___al-intruder.gd"
func _info():
	pass
var baseId = ""
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」侵扰者·Lv%d"%level    #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2	 #攻击力（每点代表8.5）
	attCoe.mgiAtk += 2  #魔法攻击（每点代表13.7）
	attCoe.def += 2	#物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	atkEff = "atk_dang" #攻击时的特效

	addSkill("普攻对当前目标身后一排的所有单位造成[物攻*1.5]({damage})的伤害", "势如破竹")
	addSkillTxt("[color=#C0C0C0]每次参加战斗即可积累经验，以提升战斗等级，升级可全方位提升实力[/color]")
	addSkillTxt("[color=#C0C0C0][现代化改造]-势如破竹伤害提高100%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()
		
func awaken(msg = true):
	isAwaken = true
	addSkillTxt("[color=#C0C0C0][心智觉醒]-强袭伤害提高50%")
	p3 = 4

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	p4 = 3