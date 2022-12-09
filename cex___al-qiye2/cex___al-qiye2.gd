extends "../cex___al-qiye/cex___al-qiye.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「航母」企业·Meta·Lv%d"%level   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2	 #攻击力（每点代表8.5）
	attCoe.mgiAtk += 2  #魔法攻击（每点代表13.7）
	attCoe.def += 1	#物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("每{cd}秒让全体敌人获得：攻速-30%、额外承伤30%、沉默，持续2秒[color=#DC143C][100层解锁][/color]", "灰色幽灵", "greyGhost", 10)
	addSkillTxt("[color=#C0C0C0]每次参加战斗即可积累经验，以提升战斗等级，升级可全方位提升实力[/color]")
	addSkillTxt("[color=#C0C0C0][现代化改造]-LuckyE所有相关效果触发概率提高8%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	if isAwaken:
		addSkillTxt("[color=#C0C0C0][心智觉醒]-法术穿透+50%")
		
func awaken(msg = true):
	isAwaken = true
	updateTmpAtt("mgiPenL", 0.5)
	addSkillTxt("[color=#C0C0C0][心智觉醒]-法术穿透+50%")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="greyGhost" and difficult.step >= 100:
		greyGhost()

func greyGhost():
	utils.createSkillTextEff("灰色幽灵", position)
	var chas = getAllChas(1)
	for i in chas:
		if not i.isDeath and i.hasBuff("b_qiye") == null and i.hasBuff("b_qiye2") == null:
			i.addBuff(b_qiye.new(2))
			i.addBuff(b_qiye2.new(5))
			for j in i.skills:
				j.nowTime -= 2

class b_qiye:
	extends Buff
	var buffName = "灰色幽灵"
	func _init(lv = 1):
		attInit()
		life = lv
		isNegetive = true
		att.spd = -0.3
		att.defR = -0.3
		id = "b_qiye"

class b_qiye2:
	extends Buff
	var dispel = 2
	func _init(lv = 1):
		attInit()
		life = lv
		id = "b_qiye2"
