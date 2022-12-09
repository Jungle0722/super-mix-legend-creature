extends "../cex___als-avrora/cex___als-avrora.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」阿芙乐尔·改"   #角色的名称
	attCoe.atkRan = 3
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("本回合内，每{cd}秒，随机使一名友军阵营变为北方联合，使一名敌人阵营变为铁血", "改变时代的炮声", "gbsddps", 5)

	addSkillTxt("[color=#C0C0C0][现代化改造]-北方联合舰队提供的伤害加成、易伤+25%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	p3_1 = 1.75
	p3_2 = 0.75
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "gbsddps":
		for i in getAllChas(1):
			if i.get("camp") != "铁血" and i.get("campTmp") != "铁血" and i.get("tag") == "azurline" and not i.isSumm:
				i.campTmp = "铁血"
				break
		for i in getAllChas(2):
			if i.get("camp") != "北方联合" and i.get("campTmp") != "北方联合" and i.get("tag") == "azurline" and not i.isSumm:
				i.campTmp = "北方联合"
				break