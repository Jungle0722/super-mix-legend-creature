extends "../cazurlineD_2/cazurlineD_2.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「战列」胡德"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	lv = 3             #等级的设置
	evos = ["cex___al-hood2"]

	addSkill("每{cd}秒赋予全体友军6层[狂怒][急速]", "皇家舰队的荣耀", "fleetHonor", 7)
	addSkill("由于弹药库的致命缺陷，胡德在受到攻击时，有3%的几率立即去世", "致命缺陷")

	autoGetSkill()
	supportSpecEvo = 2
	setCamp("皇家")
	canCopy = false
var p3 = 6
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="fleetHonor":
		cast()

func cast():
	utils.createSkillTextEff("皇家舰队的荣耀", position)
	var ally=getAllChas(2)
	for i in ally:
		if not i.isDeath:
			i.addBuff(buffUtil.b_kuangNu_r.new(p3))
			i.addBuff(buffUtil.b_jiSu_r.new(p3))

func _onHurt(atkInfo:AtkInfo):
	._onHurt(atkInfo)
	if not upgraded and sys.rndPer(3) && atkInfo.atkType == AtkType.NORMAL && not atkInfo.atkCha.isSumm && not atkInfo.isMiss:
		forceKillCha(self)
		if team == 1:
			sys.newBaseMsg("重大喜讯", "胡德酱又双叒叕炸啦！")
			for i in getAllChas(2):
				if i.id == "cazurlineD_4_2_1" and not i.isAwaken:
					i.awakenProcess += 1
					i.addBuff(buffUtil.b_spd.new(10))
					if i.awakenProcess >= 4 and not i.isAwaken:
						i.awaken()
