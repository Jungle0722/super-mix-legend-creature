extends "../cazurlineE_2/cazurlineE_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」企业"   #角色的名称
	attCoe.maxHp += 3   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 1     #攻击力（每点代表8.5）
	lv = 3             #等级的设置
	evos = ["cazurlineE_2_1_1"]
	addSkill("每{cd}秒，指挥自身所有舰载机对当前目标发起总攻，造成[自身法强*3]的真实伤害", "致命俯冲", "critDive", 8)
	autoGetSkill()
	setCamp("白鹰")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="critDive" and aiCha != null:
		critDive()

func critDive():
	for i in summedCha:
		if team == 1:
			azurHurtChara(aiCha, att.mgiAtk * 3, Chara.HurtType.REAL, Chara.AtkType.SKILL, "致命俯冲")
		else:
			azurHurtChara(aiCha, att.mgiAtk * 5, Chara.HurtType.PHY, Chara.AtkType.SKILL, "致命俯冲")
