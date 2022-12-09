extends "../cex___siren-explorer1/cex___siren-explorer1.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「塞壬」探索者II型"   #角色的名称
	attCoe.atk += 1
	attAdd.suck += 0.1
	lv = 3             #等级的设置
	addSkillTxt("[稳步前进]-25%格挡普攻，格挡后立即<反击>")
	evos = ["cex___siren-explorer3"]

func sort(a,b):
	return a.lv < b.lv

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL && sys.rndPer(25):
		.normalAtkChara(atkInfo.atkCha)



