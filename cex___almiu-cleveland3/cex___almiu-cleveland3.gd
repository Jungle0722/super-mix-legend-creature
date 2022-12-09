extends "../cex___almiu-cleveland2/cex___almiu-cleveland2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」克利夫兰·μ兵装"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5））
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	skillStrs.pop_back()
	addSkill("每{cd}秒使全体敌人负面效果层数提高5层并附加2层<强袭号令>，全体友军获得2层<活力>", "兵装解放", "mbzjf", 10)

	addSkillTxt(jbText)
	addSkillTxt("[color=#C0C0C0][现代化改造]-所罗门传说对目标的伤害提高[μ兵装舰娘人数*50%](未解锁)")
	if isInManual():
		addSkillTxt("[color=#C0C0C0][兵装解放强化]-Lv1：额外2层强袭号令、活力效果，Lv2：额外4层强袭号令、活力效果")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="mbzjf":
		mbzjf()

func mbzjf():
	utils.createSkillTextEff("μ兵装·解放", position)
	var chas = getAllChas(1)
	for i in chas:
		for j in i.buffs:
			if j.get("type") != config.EQUITYPE_EQUI and j.life != null and j.life > 0 and j.isNegetive and j.id != "b_xuanYun":
				j.life = min(20, j.life+5)
		i.addBuff(b_qxhl.new(p4))

	for i in getAllChas(2):
		buffUtil.addHuoLi(i, self, p4)
