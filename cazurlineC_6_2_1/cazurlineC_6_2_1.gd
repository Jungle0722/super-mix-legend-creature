extends "../cazurlineC_6_2/cazurlineC_6_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」海因里希亲王·改"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.atk += 2  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("<唯一>护盾充能时，周围2格的友军也获得[该次充能值50%]的护盾，对铁血阵营队友效果翻倍", "交流协议")

	addSkillTxt("[color=#C0C0C0][现代化改造]-击杀目标时立即再次施放一次直感之拳(内置冷却3秒)(未解锁)")
	p4Flag = true
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")