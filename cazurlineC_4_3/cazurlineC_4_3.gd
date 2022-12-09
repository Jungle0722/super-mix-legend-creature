extends "../cazurlineC_4/cazurlineC_4.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「重巡」埃克塞特"   #角色的名称
	attCoe.atk += 1     #物理防御（每点代表15）
	attCoe.maxHp += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cazurlineC_4_3_1"]
	addSkill("触发连续射击时，随机向2名敌人发射一枚延迟引信炮弹，5秒后引爆使其获得6层<烧蚀>且\n受到[攻击*3]的真实技能伤害<高强度>", "延迟引信")
	ename = "aikesaite"
	autoGetSkill()
	setCamp("皇家")

