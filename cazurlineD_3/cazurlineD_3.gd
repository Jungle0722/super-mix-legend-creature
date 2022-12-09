extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」罗德尼"   #角色的名称
	attCoe.atkRan = 1  #攻击距离
	attCoe.maxHp = 6   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 3     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 2  #魔法攻击（每点代表13.7）
	attCoe.def = 4     #物理防御（每点代表15）
	attCoe.mgiDef = 4  #魔法防御（每点代表16.6）
	attAdd.reHp += 0.3
	lv = 2             #等级的设置
	evos = ["cazurlineD_3_1","cazurlineD_3_2"]
	addSkill("开局获得15层[抵御][魔御]，受到攻击时获得2层[抵御][魔御]，被治疗效果提高30%", "BigSeven级防护")

	prefer = "t"
	setCamp("皇家")
	setGunAndArmor("大型","超重型")

func _onBattleStart():
	._onBattleStart()
	addBuff(buffUtil.b_moYu_r.new(15))
	addBuff(buffUtil.b_diYu_r.new(15))

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	addBuff(buffUtil.b_moYu_r.new(2))
	addBuff(buffUtil.b_diYu_r.new(2))