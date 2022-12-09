extends "../azurline_ctrl/TBF.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「鱼雷机」剑鱼·818中队"   #角色的名称
	attCoe.mgiAtk += 2
	lv = 4             #等级的设置
	addSkillTxt("每7秒为所有敌方单位附加4层漏水")
	addCdSkill("818", 7)
	addCdSkill("sk", 5)
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "818":
		var chas = getAllChas(1)
		for i in chas:
			buffUtil.addLouShui(i, self, 4)
	if id == "sk" && flag:
		qx()
	
var baseId = ""

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
		hurtChara(cha, min(cha.att.maxHp*1.2, att.mgiAtk*2), Chara.HurtType.MGI, Chara.AtkType.SKILL)
