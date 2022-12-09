extends "../cazurlineC_4_2/cazurlineC_4_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」布莱默顿·誓约"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.atk += 3  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("每次造成伤害时，随机产生[半伤、全伤、毁灭打击]效果，其中毁灭打击效果为神圣伤害", "不稳定火力")

	setCamp("白鹰")
	addSkillTxt("[color=#C0C0C0][现代化改造]-不稳定火力不再产生半伤效果(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if team == 2:return
	if not upgraded:
		match sys.rndRan(1, 3):
			1:
				atkInfo.hurtVal *= 0.5
			3:
				atkInfo.hurtVal = 0
				holyDmg(atkInfo.hitCha, atkInfo.atkVal, "不稳定火力")
	else:
		if sys.rndPer(50):
			atkInfo.hurtVal = 0
			holyDmg(atkInfo.hitCha, atkInfo.atkVal, "不稳定火力")

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
