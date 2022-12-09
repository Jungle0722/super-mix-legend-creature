extends "../cex___siren-chess2/cex___siren-chess2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」执棋者Ⅲ型"   #角色的名称
	attCoe.maxHp += 4
	lv = 4             #等级的设置
	addSkillTxt("[悔棋]-每5秒使一名生命值最低的友军满血(对塞壬效果削弱80%)")
	addCdSkill("hq", 8)

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="hq":
		hq()

func hq():
	var chas = getAllChas(2)
	chas.sort_custom(self, "sort")
	var cha = chas[0]
	if cha != null && not cha.isDeath:
		if cha.get("type") == "BOSS":
			healCha(chas[0], chas[0].att.maxHp * 0.1)
		else:
			healCha(chas[0], chas[0].att.maxHp)

func sort(a,b):
	return (!a.isSumm && b.isSumm && a.att.maxHp - a.att.hp > 50) || a.att.hp / a.att.maxHp < b.att.hp / b.att.maxHp
