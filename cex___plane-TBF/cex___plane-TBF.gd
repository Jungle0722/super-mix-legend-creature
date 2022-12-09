extends "../azurline_ctrl/TBF.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「鱼雷机」TBF复仇者"   #角色的名称
	addSkillTxt("每5秒对随机2名敌人造成[法强*2.5]的可暴击伤害")
	addCdSkill("sk", 5)

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "sk":
		var chas = getAllChas(1)
		chas.shuffle()
		for i in range(2):
			if i >= chas.size() : break
			var d:Eff = newEff("sk_feiDang",sprcPos)
			d._initFlyCha(i)
			yield(d,"onReach")
			var dmg = att.mgiAtk*2.5
			if sys.rndPer(att.cri*100):
				dmg *= 2 + att.criR
			hurtChara(chas[i], min(chas[i].att.maxHp*1.5, dmg), Chara.HurtType.MGI, Chara.AtkType.SKILL)
