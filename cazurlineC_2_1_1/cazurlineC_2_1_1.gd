extends "../cazurlineC_2_1/cazurlineC_2_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」波特兰·改"   #角色的名称
	attCoe.atkRan = 2  #攻击距离
	attCoe.atk += 2     #攻击力（每点代表8.5）
	attCoe.def += 2
	attCoe.mgiDef += 2
	attCoe.maxHp += 2
	lv = 4             #等级的设置
	addSkill("每格挡5次，对当前目标及周围(十字范围)的敌人发起普攻", "反应装甲")

	addSkillTxt("[color=#C0C0C0][现代化改造]-格挡成功后<反击>(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setCamp("白鹰")
	lv4Flag = true
	addSkillTxt("[color=#C0C0C0]在波特兰认为自己的力量不足以保护妹妹印第安纳波利斯时，方是她真正觉醒的时候")
	if isAwaken:
		awaken()

var baseId = ""

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")

func awaken(msg = true):
	chaName = "「重巡」波特兰·觉醒"
	addSkill("装甲类型变为超重型", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "波特兰已经获得了心智觉醒！")
		isAwaken = true
	setArmor("超重型")