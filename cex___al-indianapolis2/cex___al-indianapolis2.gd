extends "../cex___al-indianapolis/cex___al-indianapolis.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」印第安纳波利斯·觉醒"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 1     #攻击力（每点代表8.5））
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	attAdd.maxHpL += 1
	attAdd.defL += 0.3
	attAdd.mgiDefL += 0.3
	lv = 4             #等级的设置
	addSkill("血上限提高100%，护甲/魔抗提高30%", "心智觉醒")
	addSkillTxt("[color=#C0C0C0][现代化改造]-<固化>每10秒触发一次自身亡语效果(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""
	
var flag = 0
func _upS():
	._upS()
	flag += 1
	if flag >= 10 and upgraded:
		deathWord()
		flag = 0

func _onBattleEnd():
	._onBattleEnd()
	flag = 0