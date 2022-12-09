extends "../azurline_ctrl/Siren.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」测试者β型·Lv%d"%level   #角色的名称
	lv = 3             #等级的设置
	attCoe.atkRan = 4  #攻击距离
	attCoe.maxHp = 5   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 5	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 5  #魔法攻击（每点代表13.7）
	attCoe.def = 5	#物理防御（每点代表15）
	attCoe.mgiDef = 5  #魔法防御（每点代表16.6）
	evos = ["cex___al-testerb2"]
	addSkill("每{cd}秒使敌方物攻最高者对其自身普攻3次", "攻击测试", "atkTest", 6)
	addSkill("每{cd}秒对当前目标周围2格的敌人造成[双防*4]的真实伤害", "防御测试", "defTest", 8)
	if id == "cex___al-testerb":
		addSkillTxt("[color=#C0C0C0]参加18场战斗后，将进化为传奇单位[/color]")
	
func levelUp():
	.levelUp()
	updateAtt()

func updateAtt():
	updateTmpAtt("maxHp", 50, false)
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
		updateTmpAtt("def", 150, false)
		updateTmpAtt("mgiDef", 150, false)
		updateTmpAtt("cd", 0.2, false)
	upAtt()

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="atkTest":
		atkTest()
	if id=="defTest":
		defTest()
var p1 = 3
func atkTest():
	var chas = getAllChas(1)
	chas.sort_custom(self, "sort2")
	for i in range(p1):
		chas[0].normalAtkChara(chas[0])
#防御测试系数		
var p2 = 4
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
	if atkInfo.isCri:
		atkInfo.hurtVal *= 0.3
	if lv == 4 and immuneable && atkInfo.hurtVal >= att.hp:
		healCha(self, atkInfo.atkCha.att.maxHp * 3)
		utils.createSkillTextEff("命运颠倒", position)
		atkInfo.hurtVal = 0
		immuneable = false
		forceKillCha(atkInfo.atkCha)

var immuneable = true
