extends "../azurline_ctrl/Siren.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「塞壬」代行者III·Lv%d"%level    #角色的名称
	lv = 3             #等级的设置
	attCoe.atkRan = 4#攻击距离
	attCoe.maxHp = 5#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 4     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 4  #魔法攻击（每点代表13.7）
	attCoe.def = 4     #物理防御（每点代表15）
	attCoe.mgiDef = 4#魔法防御（每点代表16.6）
	atkEff = "atk_gongJian" #攻击时的特效
	evos = ["cex___al-executer-a2"]
	addSkill("每{cd}秒对所有敌人造成[攻击*0.2]的技能伤害，本回合内，本技能每次使用后伤害翻倍", "徐进弹幕", "xjdm", 12)
	addSkill("降低所有敌人20%暴击、爆伤<弱效果>", "抗暴立场")
	if id == "cex___al-executer-a":
		addSkillTxt("[color=#C0C0C0]参加18场战斗后，将进化为传奇单位[/color]")

func levelUp():
	.levelUp()
	updateAtt()
	
func updateAtt():
	updateTmpAtt("maxHp", 100, false)
	updateTmpAtt("atk", 15, false)
	updateTmpAtt("mgiAtk", 15, false)
	updateTmpAtt("def", 15, false)
	updateTmpAtt("mgiDef", 15, false)
	if level == 20 and gSiren.sirenAwaken:
		call("awaken")
		updateTmpAtt("maxHp", 1000, false)
		updateTmpAtt("atk", 150, false)
		updateTmpAtt("mgiAtk", 150, false)
		updateTmpAtt("def", 150, false)
		updateTmpAtt("mgiDef", 150, false)
	upAtt()
	

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "xjdm":
		xjdm()
var p1 = 0.2
func xjdm():
	var dmg = att.atk*p1
	if upgraded:
		dmg * 2
	for i in getAllChas(1):
		azurHurtChara(i, att.atk*p1, Chara.HurtType.PHY, Chara.AtkType.SKILL, "徐进弹幕")
	p1 = min(50, p1 * 2)

# var flag = 9
# func _upS():
# 	._upS()
# 	flag += 1
# 	if flag >= 10:
# 		xjdm()
# 		flag = 0

func _onBattleStart():
	._onBattleStart()
	p1 = 0.5
	for i in getAllChas(1):
		castBuff(i, b_executer_a.new())

class b_executer_a:
	extends Buff
	var buffName = "抗暴立场"
	func _init():
		attInit()
		id = "b_executer_a"
		isNegetive = true
		att.cri = -0.2
		att.criR = -0.2
	func _connect():
		if casCha.isAwaken:
			att.defL = -0.2