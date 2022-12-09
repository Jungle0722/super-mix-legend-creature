extends "../cex___siren/cex___siren.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」领洋者I型"   #角色的名称
	lv = 2             #等级的设置
	attCoe.maxHp = 10
	attAdd.spd += 0.2
	addSkillTxt("[巡洋]-普攻时，额外瞄准2个目标")
	evos = ["cex___siren-seaLeader2"]
	
func normalAtkChara(cha):
	var chas = getCellChas(cell, att.atkRan, 1)
	chas.sort_custom(self,"sortByDistance")
	for i in range(2):
		if i >= chas.size():break
		.normalAtkChara(chas[i])
	.normalAtkChara(cha)

