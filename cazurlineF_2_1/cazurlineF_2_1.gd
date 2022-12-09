extends "../cazurlineF_2/cazurlineF_2.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「辅助」明石·奸商型"   #角色的名称
	attCoe.maxHp += 2
	attCoe.def += 2
	attCoe.mgiDef += 2
	lv = 3             #等级的设置
	evos = ["cazurlineF_2_1_1"]
	addSkill("战斗结束时若存活，则获得[敌我双方装备总数/1.8]的金钱", "奸商")

	autoGetSkill()
	setCamp("重樱")
	itemEvoCha = "cex___al-mingShi"
var jsFlag = true
func _onBattleEnd():
	._onBattleEnd()
	if team == 1 and jsFlag:
		var num = 0
		var chas=getAllChas(0)
		for i in chas:
			num += i.items.size()
		if num > 0:
			sys.main.player.plusGold(num/1.8)
			if upgraded:
				sys.main.player.plusEmp(num/1.8)
	jsFlag = true


func _onDeath(atkInfo):
	._onDeath(atkInfo)
	jsFlag = false