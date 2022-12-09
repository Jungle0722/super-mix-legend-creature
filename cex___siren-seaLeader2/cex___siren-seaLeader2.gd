extends "../cex___siren-seaLeader1/cex___siren-seaLeader1.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「塞壬」领洋者II型"   #角色的名称
	lv = 3             #等级的设置
	attCoe.maxHp += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	attAdd.spd += 0.35
	addSkillTxt("[引导]-赋予被普攻命中的单位1层<暴露>，最多3层")
	evos = ["cex___siren-seaLeader3"]
	
func _onNormalAtk(cha):
	._onNormalAtk(cha)
	var b = cha.hasBuff("b_expose")
	if b == null:
		cha.addBuff(buffUtil.b_expose.new(1))
	elif b.p1 < 4:
		b.reset(1)


