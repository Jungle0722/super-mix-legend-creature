extends "../cex___almiu-dido/cex___almiu-dido.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「轻巡」黛朵·μ兵装"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4
	skillStrs.pop_back()
	addSkill("每{cd}秒对当前目标造成[法强*友军正面效果总数*1]的伤害", "兵装解放", "equipRelease", 12)
	addSkillTxt(jbText)
	addSkillTxt("[color=#C0C0C0][现代化改造]-冷却速度提高[10%*μ兵装舰娘人数](未解锁)")
	if isInManual():
		addSkillTxt("[color=#C0C0C0][兵装解放强化]-Lv1：伤害系数提升为2，Lv2：伤害系数提升为3")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onBattleStart():
	._onBattleStart()
	addBuff(buffUtil.b_cd.new(miuNum))

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="equipRelease" and aiCha != null:
		equipRelease()

func equipRelease():
	utils.createSkillTextEff("兵装解放", position)
	var count = 1
	for i in getAllChas(2):
		for j in i.buffs:
			if not j.isNegetive && j.get("type") != config.EQUITYPE_EQUI:
				count += 1
	azurHurtChara(aiCha, att.mgiAtk*count*p4, Chara.HurtType.PHY, Chara.AtkType.SKILL, "兵装解放")