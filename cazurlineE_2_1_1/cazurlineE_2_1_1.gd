extends "../cazurlineE_2_1/cazurlineE_2_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」企业·誓约"   #角色的名称
	attCoe.maxHp += 3   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 3     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 3
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("施放技能后，35%概率刷新该技能的冷却时间，造成技能伤害时，15%概率放大10倍伤害", "LuckyE")

	if id == "cazurlineE_2_1_1" or id == "cex___alawaken-E211":
		addSkillTxt("[color=#C0C0C0][现代化改造]-LuckyE所有相关效果触发概率提高8%(未解锁)")
		if upgraded:
			skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
		addSkillTxt("[color=#C0C0C0]在数次被女灶神拯救于生死之间，企业对自己的力量可能会有新的感悟...")
		if isAwaken:
			awaken()
var p4 = 35
var baseId = ""
func awaken(msg = true):
	chaName = "「航母」企业·觉醒"
	addSkill("我方舰载机被击落或我方白鹰舰娘阵亡时，立即发动3轮舰炮掩护", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "企业已经获得了心智觉醒！")
	isAwaken = true

func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha) or not isAwaken:return
	if cha.team == 1 and (cha.isSumm or cha.get("camp") == "白鹰"):
		for i in range(3):
			coverShoot()

func _castCdSkill(id):
	._castCdSkill(id)
	if sys.rndPer(p4):
		var skill = getSkill(id)
		skill.nowTime += skill.cd/(1+att.cd)

func upgrade():
	p4 = 43
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.SKILL and atkInfo.hurtVal > 10 and sys.rndPer(15):
		atkInfo.hurtVal *= 10
		if team == 2:
			atkInfo.hurtVal = min(atkInfo.hurtVal, atkInfo.hitCha.att.maxHp * 1.2)
