extends "../cazurlineE/cazurlineE.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」独立"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1
	lv = 2             #等级的设置
	evos = ["cazurlineE_4_1", "cazurlineE_4_2", "cazurlineE_4_3"]
	addSkill("赋予自身舰载机35%的法强、攻击加成", "装备改良")
	if id == "cazurlineE_4":
		addSkillTxt("[color=#C0C0C0]战斗30回合，则进化为特殊形态的独立！")

	setCamp("白鹰")
	if not is_connected("summChara", self, "doit"):
		connect("summChara", self, "doit")

func doit(cha):
	cha.addBuff(buffUtil.b_atkL.new(3.5))
	cha.addBuff(buffUtil.b_mgiAtkL.new(3.5))

func specEvoE4():
	sys.newBaseMsg("提示", "经历一场场艰苦卓绝的战斗，独立已今非昔比，取得了成长！")
	sys.main.player.addCha(sys.main.newChara("cex___al-independence"))
	deleteSelf()

func _onBattleEnd():
	._onBattleEnd()
	if id == "cazurlineE_4":
		level += 1
		if level > 30:
			specEvoE4()	