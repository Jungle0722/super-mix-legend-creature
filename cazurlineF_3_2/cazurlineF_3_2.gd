extends "../cazurlineF_3/cazurlineF_3.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「辅助」恐怖"   #角色的名称
	attCoe.atk += 2
	attCoe.maxHp += 1
	lv = 3             #等级的设置
	evos = ["cazurlineF_3_2_1"]
	addSkill("炮击时额外对一名随机敌方单位发起一轮必定暴击的炮击", "预装填")

	autoGetSkill()
	setCamp("皇家")

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "fire":
		fire(sys.rndListItem(getAllChas(1)), true)