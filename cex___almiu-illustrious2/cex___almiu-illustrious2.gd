extends "../cex___almiu-illustrious/cex___almiu-illustrious.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「航母」光辉·μ兵装"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4
	skillStrs.pop_back()
	addSkill("受到普攻伤害时，最多承受600点伤害，每有一名μ兵装舰娘，承伤-30", "兵装解放")
	addSkillTxt(jbText)
	addSkillTxt("[color=#C0C0C0][现代化改造]-大幅提高舰载机加成(加成与μ兵装舰娘人数有关)(未解锁)")
	if isInManual():
		addSkillTxt("[color=#C0C0C0][兵装解放强化]-Lv1：承伤阈值-50，Lv2：承伤阈值-100")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		var p4 = 500 - miuNum
		if atkInfo.hurtVal > p4:
			atkInfo.hurtVal = p4

func castPlane():
	if not upgraded:
		.castPlane()
		return
	var summ = summPlane()
	if summ != null && not summ.isDeath:
		var ap = float(att.maxHp)
		var baseBonus = 10.0
		if upgraded:
			baseBonus /= (1 + miuNum*0.3)
		summ.attAdd.maxHp += ap*lv/baseBonus
		summ.plusHp(ap*lv/baseBonus)
		summ.attAdd.def += ap*lv/(baseBonus*10.0)
		summ.attAdd.mgiDef += ap*lv/(baseBonus*10.0)
		summ.attAdd.atk += ap*lv/(baseBonus*4.0)
		summ.upAtt()