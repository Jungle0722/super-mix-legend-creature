extends "../cex___almiu-malin/cex___almiu-malin.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「驱逐」恶毒·μ兵装"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4
	skillStrs.pop_back()
	addSkill("每{cd}秒对[我方μ兵装角色数]的随机敌人施放[嫉妒]", "兵装解放", "equipRelease", 12)
	addSkillTxt(jbText)
	addSkillTxt("[color=#C0C0C0][现代化改造]-嫉妒造成的法强降低提高至50%且无法被驱散(对塞壬效果减半)(未解锁)")
	if isInManual():
		addSkillTxt("[color=#C0C0C0][兵装解放强化]-Lv1：施放次数+2，Lv2：施放次数+6")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	jiduFlag = true
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="equipRelease":
		equipRelease()

func equipRelease():
	utils.createSkillTextEff("兵装解放", position)
	for i in range(miuNum+p4):
		jiDu(utils.getRndEnemy(self))