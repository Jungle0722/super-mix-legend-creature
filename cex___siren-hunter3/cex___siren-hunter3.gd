extends "../cex___siren-hunter2/cex___siren-hunter2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」追迹者Ⅲ型"   #角色的名称
	attAdd.spd += 0.3
	lv = 4             #等级的设置
	addSkillTxt("[神迹]-攻击附带[魔攻*1]的真实伤害")
	
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		azurHurtChara(atkInfo.hitCha, min(atkInfo.hitCha.att.maxHp * 0.5, att.mgiAtk), Chara.HurtType.REAL, Chara.AtkType.EFF, "神迹")

