extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」北卡罗来纳"   #角色的名称
	attCoe.maxHp += 3   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___als-northCarolina2"]
	canCopy = false
	addSkill("受到的非普攻伤害降低50%", "普列塞结构")
	addSkill("受到普攻伤害后恢复其30%的血量", "剥被帽装甲")
	ename = "beikaluolaina"
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("白鹰")
	setGunAndArmor("大型","超重型")

var p3 = 0.3
func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		healCha(self, atkInfo.hurtVal*p3)
	else:
		atkInfo.hurtVal *= 0.5