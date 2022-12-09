extends "../cazurlineB/cazurlineB.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」五十铃"   #角色的名称
	attCoe.atkRan = 5  #攻击距离
	attCoe.atk += 1
	attCoe.mgiDef += 1
	lv = 2             #等级的设置
	atkEff = "atk_gongJian" #攻击时的特效
	evos = ["cazurlineB_2_1","cazurlineB_2_2","cazurlineB_2_3"]
	addSkill("每次普攻获得3层<振奋>，并赋予目标3层<烧蚀><流血>", "狩猎标记")
	setGunAndArmor("小型","中型")
	setCamp("重樱")

func _onNormalAtk(cha):
	if not is_instance_valid(cha):return
	._onNormalAtk(cha)
	if cha != null && not cha.isDeath:
		addBuff(buffUtil.b_zhenFen.new(3))
		cha.addBuff(buffUtil.b_shaoShi.new(3))
		cha.addBuff(buffUtil.b_liuXue_r.new(3))
