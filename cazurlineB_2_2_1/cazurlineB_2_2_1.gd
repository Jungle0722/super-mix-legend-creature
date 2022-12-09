extends "../cazurlineB_2_2/cazurlineB_2_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」海伦娜·幼"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 1
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("每{cd}秒强行施放1名随机队友的所有CD技能", "强制冷却", "forceCooldown", 8)
	addSkillTxt("[color=#C0C0C0][现代化改造]-施放技能有10%概率再次施放(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

	addSkillTxt("[color=#C0C0C0]与克利夫兰共同经历一次次战斗，可能会使海伦娜对自己的使命有更深刻的认识...")	
	if isAwaken:
		awaken()


func awaken(msg = true):
	chaName = "「轻巡」海伦娜·觉醒"
	addSkill("战斗开始时，额外施放两次雷达扫描", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "海伦娜已经获得了心智觉醒！")
		isAwaken = true

var baseId = ""
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "forceCooldown":
		forceCooldown()
	if upgraded and sys.rndPer(10):
		var skill = getSkill(id)
		skill.nowTime += skill.cd/(1+att.cd)

func forceCooldown():
	utils.createSkillTextEff("强制冷却", position)
	var chas = getAllChas(2)
	chas.shuffle()
	for i in range(chas.size()):
		if chas[i].skills.size() == 0 || chas[i].id == id:continue
		utils.createSkillTextEff("清空冷却", chas[i].position)
		for j in chas[i].skills:
			j.nowTime += j.cd
		break

var p4 = 0
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	p4 = 1

func _onBattleStart():
	._onBattleStart()
	for i in getAllChas(2):
		if i.chaName.find("克利夫兰") >= -1:
			awakenProcess += 1
			if awakenProcess >= 35 and not isAwaken:
				awaken()

	if isAwaken:
		radarScanning()
		radarScanning()