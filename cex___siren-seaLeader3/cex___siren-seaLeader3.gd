extends "../cex___siren-seaLeader2/cex___siren-seaLeader2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」领洋者Ⅲ型"   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	attCoe.spd += 0.5
	addSkillTxt("[领洋]-每5秒，赋予全体友军5层<振奋>")
	addCdSkill("ly", 5)

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="ly":
		ly()

func ly():
	for i in getAllChas(2):
		if not i.isDeath:
			i.addBuff(buffUtil.b_zhenFen.new(5))
