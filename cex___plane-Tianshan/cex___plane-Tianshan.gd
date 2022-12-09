extends "../azurline_ctrl/TBF.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「鱼雷机」天山"   #角色的名称
	addSkillTxt("每5秒对前方一行的所有敌人造成[法强*2.5]的伤害")
	addCdSkill("sk", 5)

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "sk":
		qx()

func qx():
	if aiCha != null:
		var eff:Eff = newEff("sk_chuanTouJian",sprcPos)
		eff._initFlyPos(position + (aiCha.position - position).normalized() * 1000, 400)
		eff.connect("onInCell",self,"effInCell")

func effInCell(cell):
	var cha = matCha(cell)
	if cha == null:
		cha = matCha(cell + Vector2(0, 1))
	if cha != null && cha.team != team :
		hurtChara(cha, min(cha.att.maxHp*1.2, att.mgiAtk * 2.5), Chara.HurtType.MGI, Chara.AtkType.SKILL)

