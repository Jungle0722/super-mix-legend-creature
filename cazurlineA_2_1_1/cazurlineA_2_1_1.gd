extends "../cazurlineA_2_1/cazurlineA_2_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」凯旋·改"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 3
	lv = 4             #等级的设置
	addSkill("对所有胆敢使用技能的敌人造成[法强*2]({damage})的技能伤害", "火力反击")
	addSkillTxt("[color=#C0C0C0][现代化改造]-剑刃风暴持续时间+2秒，范围加1(未解锁)")
	addSkillTxt("[color=#C0C0C0]在一次次的施展剑刃风暴后，凯旋逐渐有了新的领悟...")
	if upgraded:
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	cmBuffFlag = false
	setCamp("自由鸢尾")
	if isAwaken:
		awaken()

var baseId = ""

func awaken(msg = true):
	chaName = "「驱逐」凯旋·觉醒"
	addSkill("剑刃风暴伤害类型升级为真实伤害", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "凯旋已经获得了心智觉醒！")
	isAwaken = true

func _onCharaCastCdSkill(cha,id):
	._onCharaCastCdSkill(cha,id)
	if cha.team != self.team and not isDeath:
		var dmg = getSkillEffect("火力反击")
		if team == 2:
			dmg *= 0.5
			dmg = min(cha.att.maxHp * 0.3, dmg)
		azurHurtChara(cha, dmg, Chara.HurtType.MGI, Chara.AtkType.SKILL, "火力反击")

func upgrade():
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	p3 = 5
	p3_1 = 2