extends "../cazurlineB_7_1/cazurlineB_7_1.gd"
func _info():
	pass
var baseId = ""
func _extInit():
	._extInit()
	chaName = "「轻巡」基洛夫·改"   #角色的名称
	attCoe.atk += 2     #攻击力（每点代表8.5）
	attCoe.mgiAtk += 1     #攻击力（每点代表8.5）
	attCoe.maxHp += 1
	lv = 4             #等级的设置
	addSkill("<固化>每10秒引爆所有敌人的<漏水>效果，使剩余伤害立即结算", "损害放大", "sunhaiFD")
	addSkillTxt("[color=#C0C0C0][现代化改造]-重击冰魄伤害提高50%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setGunAndArmor("中型","中型")

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func sunhaiFD():
	for i in getAllChas(1):
		var bf = i.hasBuff("b_louShui")
		if bf != null:
			bf.allDmg()

var flag = 0
func _upS():
	._upS()
	flag += 1
	if flag >= 10:
		sunhaiFD()
		flag = 0

func _onBattleEnd():
	._onBattleEnd()
	flag = 0