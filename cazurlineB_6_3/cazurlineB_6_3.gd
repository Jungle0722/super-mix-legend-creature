extends "../cazurlineB_6/cazurlineB_6.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「轻巡」莱比锡"   #角色的名称
	attCoe.mgiDef += 1
	attCoe.atk += 1
	lv = 3             #等级的设置
	evos = ["cazurlineB_6_3_1"]
	addSkill("普攻赋予目标3层<活力>", "安全第一")
	camp = "铁血"
	autoGetSkill()
	ename = "laibixi"	
