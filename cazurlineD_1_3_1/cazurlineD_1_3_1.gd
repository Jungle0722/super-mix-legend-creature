extends "../cazurlineD_1_3/cazurlineD_1_3.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」土佐·花嫁"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 2
	attCoe.mgiDef += 1
	attCoe.atk += 3     #攻击力（每点代表8.5）
	lv = 4             #等级的设置
	addSkill("对敌方单位首次攻击时，额外造成[攻击*3]的必定暴击伤害(每名敌人触发一次)", "威慑")

	addSkillTxt("[color=#C0C0C0][现代化改造]-BigSeven触发阈值下调为2次(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""
func upgrade():
	p2 = 2
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var atkedChas = []
func _onBattleEnd():
	._onBattleEnd()
	atkedChas.clear()

func _onAtkInfo(atkInfo):
	._onAtkInfo(atkInfo)
	if not atkedChas.has(atkInfo.hitCha):
		atkedChas.append(atkInfo.hitCha)
		var dmg = att.atk * (2 + att.criR) * 3
		azurHurtChara(atkInfo.hitCha, dmg, Chara.HurtType.PHY, Chara.AtkType.NORMAL, "威慑")
