extends "../cex___siren/cex___siren.gd"

func _extInit():
	._extInit()
	setGunAndArmor("要塞级","超重型")
	if difficult.difficult > 4:
		if giftCha == null and difficult.step > 105:
			attAdd.atkR += 0.2 * (difficult.difficult - 3)
			attAdd.spd += 0.2 * (difficult.difficult - 3)
			attAdd.cd += 0.1 * (difficult.difficult - 3)
			attAdd.maxHpL += 0.4 * (difficult.difficult - 3)
			if difficult.difficult == 7:
				attAdd.atkL += 0.2
				attAdd.mgiAtkL += 0.2
			upAtt()

	if 	giftCha	!= null and difficult.difficult >= 6:
		attAdd.atkL += 0.1
		attAdd.mgiAtkL += 0.1
		attAdd.suck += 0.1
		attAdd.mgiSuck += 0.1
		if difficult.step < 60:
			attAdd.atkL += 0.2
			attAdd.mgiAtkL += 0.2
			attAdd.suck += 0.1
			attAdd.mgiSuck += 0.1
			attAdd.dod += 0.2
			attAdd.maxHpL += 0.2
		upAtt()

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	atkInfo.hurtVal *= 0.8

var delFlag = true
# func _onCharaDel(cha):
# 	if not is_instance_valid(cha):return
# 	if cha == self and team == 2 and giftCha != null:
# 		#执行清空机制
# 		var chara = sys.main.newChara("cex___azurtoolmanGM", 1)
# 		sys.main.map.add_child(chara)
# 		chara.isSumm = true
# 		for i in getAllChas(2):
# 			i.forceHurtSelf(i.maxHp)	
# 	if isDeath || cha.team != 1 || not isHead || not delFlag:return
# 	if getAllChas(1).size() == 1:
# 		print("执行BOSS战败保护机制")
# 		flag = true
# 		var chara = sys.main.newChara("cex___azurtoolmanGM", 1)
# 		sys.main.map.add_child(chara)
# 		chara.isSumm = true
# 		if flag:
# 			gSiren.challengeFail()
# 		flag = false
# 		for i in getAllChas(2):
# 			forceKillCha(i)
	