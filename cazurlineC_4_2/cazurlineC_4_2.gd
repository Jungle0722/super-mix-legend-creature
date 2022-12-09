extends "../cazurlineC_4/cazurlineC_4.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「重巡」布莱默顿"   #角色的名称
	attCoe.atkRan = 5#攻击距离
	attCoe.atk += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cazurlineC_4_2_1"]
	addSkill("触发连续射击时，将目标击退1格，若存在障碍物，则额外造成[物攻*4]({damage})的伤害，并附加10层<烧蚀>", "动能打击")

	autoGetSkill()
	setCamp("白鹰")
	skFlag = true
