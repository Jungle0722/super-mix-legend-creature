extends "../cex___al-fangzhou/cex___al-fangzhou.gd"
func _info():
	pass
var baseId = ""
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「航母」皇家方舟·Meta·Lv%d"%level   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2	 #攻击力（每点代表8.5）
	attCoe.mgiAtk += 2  #魔法攻击（每点代表13.7）
	attCoe.def += 2	#物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("本回合每击杀1名非召唤敌方单位，提高30%法强、冷却速度(上限300%)", "荣光之锋")
	addSkillTxt("[color=#C0C0C0]每次参加战斗即可积累经验，以提升战斗等级，升级可全方位提升实力[/color]")
	addSkillTxt("[color=#C0C0C0][现代化改造]-舰载机变为飞龙(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()
		
func awaken(msg = true):
	isAwaken = true
	addSkillTxt("[color=#C0C0C0][心智觉醒]-荣光之锋额外叠加10%伤害")

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	crewEquipName = "「鱼雷机」飞龙"
	crewEquip = "cex___plane-FlyDragon"

func _onKillChara(atkInfo):
	._onKillChara(atkInfo)	
	if atkInfo.hitCha.isSumm:return
	var bf = hasBuff("b_fangzhou")
	if bf == null:
		bf = addBuff(b_fangzhou.new())
	if bf.att.mgiAtkL < 3:
		bf.att.mgiAtkL += 0.3
		bf.att.cd += 0.3
		if isAwaken:
			bf.att.atkR += 0.1

class b_fangzhou:
	extends Buff
	var buffName = "荣光之锋"
	var dispel = 2
	func _init(num = 0):
		attInit()
		id = "b_fangzhou"	