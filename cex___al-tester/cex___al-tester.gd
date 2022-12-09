extends "../azurline_ctrl/Siren.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」测试者α型·Lv%d"%level   #角色的名称
	lv = 3             #等级的设置
	attCoe.atkRan = 4  #攻击距离
	attCoe.maxHp = 5   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 3	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 3  #魔法攻击（每点代表13.7）
	attCoe.def = 8	#物理防御（每点代表15）
	attCoe.mgiDef = 8  #魔法防御（每点代表16.6）
	evos = ["cex___al-tester2"]
	addSkill("每{cd}秒使敌方物攻最高者对其自身普攻4次", "攻击测试", "atkTest", 8)
	addSkill("每{cd}秒对当前目标周围2格的敌人造成[双防*2]的真实伤害", "防御测试", "defTest", 8)
	if id == "cex___al-tester":
		addSkillTxt("[color=#C0C0C0]参加18场战斗后，将进化为传奇单位[/color]")
	
func levelUp():
	.levelUp()
	updateAtt()

func updateAtt():
	updateTmpAtt("maxHp", 100, false)
	updateTmpAtt("atk", 10, false)
	updateTmpAtt("mgiAtk", 10, false)
	updateTmpAtt("def", 20, false)
	updateTmpAtt("mgiDef", 20, false)
	updateTmpAtt("cd", 0.02, false)
	if level == 20 and gSiren.sirenAwaken:
		call("awaken")
		updateTmpAtt("maxHp", 1000, false)
		updateTmpAtt("atk", 100, false)
		updateTmpAtt("mgiAtk", 100, false)
		updateTmpAtt("def", 200, false)
		updateTmpAtt("mgiDef", 200, false)
		updateTmpAtt("cd", 0.2, false)
	upAtt()
#施法测试系数
var p4 = 0.4
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="atkTest":
		atkTest()
	if id=="defTest":
		defTest()
	if lv == 4:
		healCha(self, att.maxHp*0.1)
		for i in getCellChas(cell, 2, 1):
			azurHurtChara(i, att.maxHp*p4, Chara.HurtType.MGI, Chara.AtkType.SKILL, "施法测试")	

func atkTest():
	var chas = getAllChas(1)
	chas.sort_custom(self, "sort2")
	for i in range(4):
		chas[0].normalAtkChara(chas[0])
#防御测试系数		
var p2 = 2
func defTest():
	var chas = getCellChas(aiCha.cell, 2, 1)
	for i in chas:
		azurHurtChara(i, (att.def + att.mgiDef)*p2, Chara.HurtType.REAL, Chara.AtkType.EFF, "防御测试")

func sort2(a,b):
	if a.get("type") == "BOSS" && b.get("type") != "BOSS":
		return false
	return a.att.atk > b.att.atk

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.isCri and difficult.step >= 110:
		atkInfo.hurtVal *= 0.2