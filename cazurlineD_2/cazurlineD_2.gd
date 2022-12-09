extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」声望"   #角色的名称
	attCoe.atkRan = 3  #攻击距离
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5）
	lv = 2             #等级的设置
	evos = ["cazurlineD_2_1","cazurlineD_2_2","cazurlineD_2_3"]
	addSkill("对血量低于20%的敌人造成普攻伤害时，将其秒杀", "斩杀")
	setCamp("皇家")

func _onBattleStart():
	._onBattleStart()
	if hasBuff("b_zhanSha") == null:
		addBuff(buffUtil.b_zhanSha.new())