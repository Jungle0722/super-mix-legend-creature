extends "../cazurlineB/cazurlineB.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」逸仙"   #角色的名称
	attCoe.atkRan = 3  #攻击距离
	attCoe.atk += 1
	attCoe.maxHp += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 2             #等级的设置
	atkEff = "atk_gongJian" #攻击时的特效
	evos = ["cazurlineB_5_1", "cazurlineB_5_2"]
	addSkill("<亡语>死亡时为全体敌方单位附加10层<流血><烧蚀>，彻底死亡时额外附加1层<暴露>", "同赴国难")

	setGunAndArmor("小型","中型")
	setCamp("其他")

func deathWord():
	.deathWord()
	var p2 = 10
	if not isDeath:
		p2 = 5
	for i in getAllChas(1):
		i.addBuff(buffUtil.b_liuXue_r.new(p2))
		i.addBuff(buffUtil.b_shaoShi.new(p2))
		if isDeath:buffUtil.addBaoLu(i, 1)

