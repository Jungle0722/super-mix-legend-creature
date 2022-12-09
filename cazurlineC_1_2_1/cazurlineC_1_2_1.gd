extends "../cazurlineC_1_2/cazurlineC_1_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」久远·改"   #角色的名称
	attCoe.atk += 3     #攻击力（每点代表8.5）
	attCoe.def += 2
	attCoe.mgiDef += 2
	attCoe.maxHp += 2
	lv = 4             #等级的设置
	addSkill("每{cd}秒召唤9名分身，分身在场上存在3秒后退场谢幕，各自向当前目标发动鱼雷连射", "十姊妹", "tenSister", 10)

	addSkillTxt("[color=#C0C0C0][现代化改造]-鱼雷连射变为真实伤害(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="tenSister":
		tenSister()

func tenSister():
	for i in range(9):
		var cha = summChara("cex___altmp-C121", true, true)
		if cha == null:return
		cha.summoner = self
		if att.cd >= 1:cha.flag += 1
		if att.cd >= 2:cha.flag += 1	

