extends "../cex___siren-explorer2/cex___siren-explorer2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」探索者Ⅲ型"   #角色的名称
	lv = 4             #等级的设置
	addSkillTxt("[清莲火]-对施放技能的敌方单位造成[目标双攻40%]的魔法伤害")
	
func _onCharaCastCdSkill(cha,id):
	._onCharaCastCdSkill(cha,id)
	var p4 = 1
	if cha.team != self.team:
		if team == 2:
			p4 = 0.5
		azurHurtChara(cha, min((cha.att.mgiAtk+cha.att.atk) * 0.4, cha.att.maxHp * 0.6) * p4, Chara.HurtType.MGI, Chara.AtkType.SKILL, "清莲火")
