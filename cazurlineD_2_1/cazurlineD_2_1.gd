extends "../cazurlineD_2/cazurlineD_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」厌战"   #角色的名称
	attCoe.atkRan = 5
	lv = 3             #等级的设置
	evos = ["cazurlineD_2_1_1"]
	addSkill("射程提高15，离目标越远，伤害越高，对召唤单位额外造成100%伤害", "神射手")

	setCamp("皇家")
	autoGetSkill()
	itemEvoCha = "cex___al-warspite"

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == AtkType.NORMAL:
		var r = cellRan(atkInfo.hitCha.cell, cell) * 0.6
		if atkInfo.hitCha.isSumm:
			atkInfo.factor += 1
		atkInfo.factor += r
		if team == 2:
			atkInfo.hurtVal *= 0.75

func _onBattleStart():
	._onBattleStart()
	addBuff(buffUtil.b_sniper.new())
