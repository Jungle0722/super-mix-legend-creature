extends "../cazurlineB_6/cazurlineB_6.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「轻巡」天狼星"   #角色的名称
	attCoe.maxHp += 1
	attCoe.mgiDef += 1
	attCoe.atk += 1
	lv = 3             #等级的设置
	evos = ["cazurlineB_6_2_1"]
	addSkill("普攻会额外治疗两名友军目标", "群疗协议")

	autoGetSkill()
	p2 = 3
	
