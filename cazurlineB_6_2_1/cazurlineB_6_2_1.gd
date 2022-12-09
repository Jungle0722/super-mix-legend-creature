extends "../cazurlineB_6_2/cazurlineB_6_2.gd"
func _info():
	pass
var baseId = ""
func _extInit():
	._extInit()
	chaName = "「轻巡」天狼星·改"   #角色的名称
	attCoe.atk += 3     #攻击力（每点代表8.5）
	attCoe.maxHp += 1
	lv = 4             #等级的设置
	addSkill("普攻会额外对一名随机敌人造成[30%治疗量]的真实技能伤害", "自卫协议")

	addSkillTxt("[color=#C0C0C0][现代化改造]-自卫协议伤害翻倍(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setGunAndArmor("中型","中型")
	p4 = 1

func upgrade():
	p4_1 = 0.6
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")