extends "../cazurlineE_4/cazurlineE_4.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」半人马"   #角色的名称
	attCoe.maxHp += 2
	lv = 3             #等级的设置
	evos = ["cazurlineE_4_2_1"]
	addSkill("初始舰载机改为[剑鱼·818中队]，并赋予其额外技能：每5秒对前方一行的所有敌人造成[法强*2]的伤害", "剑鱼出击")

	autoGetSkill()
	setGunAndArmor("小型","轻型")
	crewEquipName = "「鱼雷机」剑鱼·818中队"
	crewEquip = "cex___plane-Swordfish-818"
	setCamp("皇家")

func castPlane():
	var cha = .castPlane()
	if crewEquip == "cex___plane-Swordfish-818":
		cha.flag = true