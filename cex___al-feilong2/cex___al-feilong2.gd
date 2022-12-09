extends "../cex___al-feilong/cex___al-feilong.gd"
func _info():
	pass
var baseId = ""
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「航母」飞龙·Meta·Lv%d"%level   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1	 #攻击力（每点代表8.5）
	attCoe.mgiAtk += 1  #魔法攻击（每点代表13.7）
	attCoe.def += 1	#物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("本回合内，我方舰载机阵亡时，获得其10%攻击(上限1000)", "战忆之樱")
	addSkillTxt("[color=#C0C0C0]每次参加战斗即可积累经验，以提升战斗等级，升级可全方位提升实力[/color]")
	addSkillTxt("[color=#C0C0C0][现代化改造]-舰载机变为实验型XSB3C-1(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()
		
func awaken(msg = true):
	isAwaken = true
	addSkillTxt("[color=#C0C0C0][心智觉醒]-对同一个目标普攻超过十次后，每次普攻将额外造成[攻击*8]的物理伤害")

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	crewEquipName = "「轰炸机」实验型XSB3C-1"
	crewEquip = "cex___plane-XSB3C"

func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha):return
	if cha.isSumm and cha.get("type") == "plane":
		var bf = hasBuff("b_feilong")
		if bf == null:
			bf = addBuff(b_feilong.new())
		if bf.att.atk < 1000:
			bf.att.atk += cha.att.atk * 0.1

class b_feilong:
	extends Buff
	var buffName = "战忆之樱"
	var dispel = 2
	func _init(num = 0):
		attInit()
		id = "b_feilong"	
		att.atk = num