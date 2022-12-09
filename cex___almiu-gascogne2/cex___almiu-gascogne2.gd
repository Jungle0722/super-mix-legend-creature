extends "../cex___almiu-gascogne/cex___almiu-gascogne.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「战列」加斯科涅·μ兵装"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4
	skillStrs.pop_back()
	addSkill("每{cd}秒弱驱散所有敌人的正面效果，并使其<眩晕>1秒", "兵装解放", "equipRelease", 10)
	addSkillTxt(jbText)
	addSkillTxt("[color=#C0C0C0][现代化改造]-兵装解放还将对目标附带[μ兵装舰娘人数*目标双防]的物理伤害(未解锁)")
	if isInManual():
		addSkillTxt("[color=#C0C0C0][兵装解放强化]-Lv1：额外延长目标1秒技能冷却，Lv2：额外赋予目标2层<暴露>")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="equipRelease":
		equipRelease()

func equipRelease():
	for i in getAllChas(1):
		weakDispel(i, false)
		i.addBuff(buffUtil.b_xuanYun.new(1))
		if p4 >= 2:
			for j in i.skills:
				j.nowTime += 1
		if p4 == 3:
			buffUtil.addBaoLu(i, 2)
		if upgraded:
			azurHurtChara(i, miuNum * (i.att.def + i.att.mgiDef), Chara.HurtType.PHY, Chara.AtkType.SKILL, "兵装解放")