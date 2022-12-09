extends Chara
func _info():
	pass

func _extInit():
	._extInit()
	chaName = "1111"   #角色的名称
	attCoe.atkRan = 3  #攻击距离
	attCoe.maxHp = 5   #最大生命（每点代表112.5，取整）
	attCoe.atk = 2	 #攻击力（每点代表8.5）
	attCoe.mgiAtk =5  #魔法攻击（每点代表13.7）
	attCoe.def = 2.5	 #物理防御（每点代表15）
	attCoe.mgiDef = 4  #魔法防御（每点代表16.6）
	lv = 3			 #等级的设置
	evos = []
	atkEff = "atk_dao" #攻击时的特效
