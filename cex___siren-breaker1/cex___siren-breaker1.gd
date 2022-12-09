extends "../cex___siren/cex___siren.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」破局者I型"   #角色的名称
	lv = 2             #等级的设置
	attCoe.maxHp = 10
	addSkillTxt("[搅局]-受到普攻伤害时将伤害转移到当前目标")
	evos = ["cex___siren-breaker2"]
	
func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		azurHurtChara(aiCha, min(aiCha.att.maxHp*0.6, atkInfo.atkVal), atkInfo.hurtType, Chara.AtkType.EFF, "搅局")

