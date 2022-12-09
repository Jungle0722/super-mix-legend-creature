extends "../cazurlineC/cazurlineC.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」阿斯托利亚"   #角色的名称
	attCoe.atkRan = 3#攻击距离
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #物理防御（每点代表15）
	lv = 2             #等级的设置
	evos = ["cazurlineC_6_1", "cazurlineC_6_2"]
	addSkill("护盾上限为5万，造成非特效伤害时，获得其数值的60%护盾", "护盾充能")

	prefer = "ad"
	setGunAndArmor("中型","中型")
	setCamp("白鹰")
	shieldLimit = 50000
var p2 = 0.6
var p4Flag = false
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType != Chara.AtkType.EFF and atkInfo.hurtVal > 1:
		var num = atkInfo.hurtVal*p2
		plusShield(num)
		if p4Flag:
			for i in getCellChas(cell, 2, 2):
				if i == self or i.chaName.find("海因里希") > -1:continue
				if i.get("camp") == "铁血":
					i.plusShield(num*2)
				else:
					i.plusShield(num)

