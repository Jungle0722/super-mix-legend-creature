extends "../cazurlineA_4_1/cazurlineA_4_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」夕立·花嫁"   #角色的名称
	attCoe.maxHp += 4   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 3     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 3
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("<限定>受到致命伤害时，和敌方血量最高的单位互换血量", "绝地反击")
	addSkillTxt("[color=#C0C0C0][现代化改造]-所罗门狂犬无触发条件，绝地反击使用过后，受到致命伤害有50%概率再次触发(未解锁)")
	addSkillTxt("[color=#C0C0C0]不断的徘徊于生死边缘，夕立逐渐有了新的领悟...")
	if upgraded:
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()

func awaken(msg = true):
	chaName = "「驱逐」夕立·觉醒"
	addSkill("血怒伤害翻倍，并对周围2格的敌人造成伤害", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "夕立已经获得了心智觉醒！")
	isAwaken = true	
	p2 = 2

var baseId = ""
var cflag = true

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if team == 1 and atkInfo.hurtVal >= att.hp and (cflag or not cflag and upgraded and sys.rndPer(50)):
		utils.createSkillTextEff("绝地反击", position)
		cflag = false
		var chas = getAllChas(1)
		chas.sort_custom(self,"sortByHpDesc")
		for i in chas:
			if i.get("type") == "BOSS":continue
			healCha(self, i.att.hp/(i.att.reHp+1))
			if team == 1:
				i.forceHurtSelf(att.hp)
		atkInfo.hurtVal = 0
		awakenProcess += 1
		if not isAwaken and awakenProcess > 10:
			awaken()
			
func _onBattleEnd():
	._onBattleEnd()
	cflag = true

func upgrade():
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")