extends "../cex___als-huteng/cex___als-huteng.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」胡滕·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("每{cd}秒对当前目标直线上的所有敌人造成2次[攻击*1]({damage})的可暴击真实伤害，深海狂暴所积累的爆伤\n将在等额提高此伤害后清空", "终结一击", "zhongjieYJ", 14)

	addSkillTxt("[color=#C0C0C0][现代化改造]-终结一击后只清空一半累积爆伤(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""
var skBf = 1
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="zhongjieYJ" and aiCha != null:
		zhongjieYJ()

func zhongjieYJ():
	utils.createSkillTextEff("终结一击", position)
	skBf = bf.att.criR + 1
	var eff2:Eff = sys.newEff("animEff", position)
	eff2.setImgs(direc + "eff/thunderFly", 9, true)
	eff2._initFlyPos(position + (aiCha.position - position).normalized() * 1000, 500)
	eff2.normalSpr.position=Vector2(0, -30)
	eff2.connect("onInCell",self,"effInCell")	
	if bf != null:
		if upgraded:
			bf.att.criR *= 0.5
		else:
			bf.att.criR = 0
	
func effInCell(cell):
	var cha = matCha(cell)
	if cha == null:
		cha = matCha(cell + Vector2(0, 1))
	if cha != null && cha.team != team:
		azurHurtChara(cha, getSkillEffect("终结一击") * skBf, Chara.HurtType.REAL, Chara.AtkType.SKILL, "终结一击", true)
		if not cha.isDeath:
			azurHurtChara(cha, getSkillEffect("终结一击") * skBf, Chara.HurtType.REAL, Chara.AtkType.SKILL, "终结一击", true)

