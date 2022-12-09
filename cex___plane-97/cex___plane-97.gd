extends "../azurline_ctrl/TBF.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「鱼雷机」九七式舰攻"   #角色的名称
	addSkillTxt("每5秒对当前目标造成[法强*5]的可暴击伤害")
	addCdSkill("97", 5)

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "97" && aiCha != null:
		var d:Eff = newEff("sk_feiDang",sprcPos)
		d._initFlyCha(aiCha)
		yield(d,"onReach")
		var dmg = att.mgiAtk*5
		azurHurtChara(aiCha, dmg, Chara.HurtType.MGI, Chara.AtkType.SKILL, "九七式舰攻", true)






