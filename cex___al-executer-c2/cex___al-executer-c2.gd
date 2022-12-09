extends "../cex___al-executer-c/cex___al-executer-c.gd"
func _info():
	pass
var baseId = ""
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「塞壬」代行者IX·Lv%d"%level    #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2	 #攻击力（每点代表8.5）
	attCoe.mgiAtk += 2  #魔法攻击（每点代表13.7）
	attCoe.def += 2	#物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	
	addSkill("每{cd}秒强驱散当前目标身上的增益效果，并使其四维降低50%(对塞壬降低10%)", "静电", "jingDian", 10)
	addSkillTxt("[color=#C0C0C0]每次参加战斗即可积累经验，以提升战斗等级，升级可全方位提升实力[/color]")

	addSkillTxt("[color=#C0C0C0][现代化改造]-额外减免50%技能伤害(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()
		
func awaken(msg = true):
	isAwaken = true
	addSkillTxt("[color=#C0C0C0][心智觉醒]-受到技能伤害时恢复5%血量")

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	p2 = 0
	
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="jingDian":
		jingDian()

func jingDian():
	for j in aiCha.buffs:
		if not j.isNegetive && j.get("type") != config.EQUITYPE_EQUI:
			j.isDel = true
	aiCha.addBuff(b_executer_c2.new())

class b_executer_c2:
	extends Buff
	var buffName = "静电"
	var dispel = 2
	func _init():
		attInit()
		id = "b_executer_c"
		isNegetive = true
	func _connect():
		var p = 0.5
		if masCha.get("type") == "BOSS":p = 0.1
		if masCha.att.atk > 0:
			att.atk -= masCha.att.atk * p
		if masCha.att.mgiAtk > 0:
			att.mgiAtk -= masCha.att.mgiAtk * p
		if masCha.att.def > 0:
			att.def -= masCha.att.def * p
		if masCha.att.mgiDef > 0:
			att.mgiDef -= masCha.att.mgiDef * p