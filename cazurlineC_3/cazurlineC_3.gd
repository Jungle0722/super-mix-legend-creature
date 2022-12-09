extends "../cazurlineC/cazurlineC.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」印第安纳波利斯"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 2             #等级的设置
	evos = ["cazurlineC_3_1","cazurlineC_3_2","cazurlineC_3_3"]
	addSkill("<亡语>死亡时，引爆携带的核弹，对周围2格的所有敌人造成[自身+目标血上限之和*0.4]的物理伤害", "核弹运输")
	
	prefer = "t"
	setGunAndArmor("中型","超重型")
	setCamp("白鹰")

	if id == "cazurlineC_3":
		addSkillTxt("[color=#C0C0C0]在印第认为自己的力量不足以保护姐姐波特兰时，方是她真正觉醒的时候")

func deathWord():
	.deathWord()
	for i in getCellChas(cell, 2, 1):
		var dmg = min(i.att.maxHp * 0.7, (att.maxHp + maxHp(i)) * 0.4)
		azurHurtChara(i, dmg, Chara.HurtType.PHY, Chara.AtkType.SKILL, "核弹运输")
	if isDeath:
		checkAwaken()

func checkAwaken():
	for i in getAllChas(2):
		if i.chaName.find("波特兰") > -1:
			i.awakenProcess += 1
			if i.awakenProcess >= 20 and not i.isAwaken:
				i.awaken()

func awaken(msg = true):
	if not isAwaken:
		sys.newBaseMsg("事件", "印第安纳波利斯已经获得了心智觉醒！")
	awakenProcess = 0
	utils.evoCha(self, "cex___al-indianapolis")