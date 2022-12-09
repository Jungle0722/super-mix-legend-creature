extends "../cazurlineC_1_1/cazurlineC_1_1.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「重巡」高雄·Meta·Lv%d"%level    #角色的名称
	lv = 3             #等级的设置
	evos = ["cex___al-gaoxiong2"]
	addSkill("击杀敌方单位时，恢复全部生命值，并对附近2格内的所有敌方单位造成[物攻*5]的伤害", "余烬")
	if id == "cex___al-gaoxiong":
		addSkillTxt("[color=#C0C0C0]参加18场战斗后，将进化为传奇单位[/color]")
	type = "siren"
	canCopy = false
	setCamp("塞壬")
	
var p4 = 5
func levelUp():
	.levelUp()
	updateAtt()

func updateAtt():
	updateTmpAtt("maxHp", 200, false)
	updateTmpAtt("atk", 15, false)
	updateTmpAtt("mgiAtk", 15, false)
	updateTmpAtt("def", 15, false)
	updateTmpAtt("mgiDef", 15, false)
	updateTmpAtt("criR", 0.02, false)
	if level == 20 and gSiren.sirenAwaken:
		call("awaken")
		updateTmpAtt("maxHp", 1500, false)
		updateTmpAtt("atk", 100, false)
		updateTmpAtt("mgiAtk", 100, false)
		updateTmpAtt("def", 100, false)
		updateTmpAtt("mgiDef", 100, false)
		updateTmpAtt("cri", 0.4, false)
	upAtt()

func _onKillChara(atkInfo:AtkInfo):
	._onKillChara(atkInfo)
	healCha(self, att.maxHp)
	var chas = getCellChas(atkInfo.hitCha.cell, 2, 1)
	for i in chas:
		if i != atkInfo.hitCha:
			azurHurtChara(i, att.atk*p4, Chara.HurtType.PHY, Chara.AtkType.SKILL, "余烬")