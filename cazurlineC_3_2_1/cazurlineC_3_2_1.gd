extends "../cazurlineC_3_2/cazurlineC_3_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」希佩尔海军上将·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5））
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("血量越低，减伤越高(上限40%)", "全方位防御")

	addSkillTxt("[color=#C0C0C0][现代化改造]-诱敌深入持续时间+2秒(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.hurtVal > 0:
		var r = att.hp/att.maxHp
		r = max(r, 0.4)
		atkInfo.hurtVal *= r

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	p3 = 7