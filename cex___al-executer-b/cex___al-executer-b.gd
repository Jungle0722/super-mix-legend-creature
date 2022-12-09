extends "../azurline_ctrl/Siren.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「塞壬」代行者VIII·Lv%d"%level    #角色的名称
	lv = 3             #等级的设置
	attCoe.atkRan = 4#攻击距离
	attCoe.maxHp = 5#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 4     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 4  #魔法攻击（每点代表13.7）
	attCoe.def = 3     #物理防御（每点代表15）
	attCoe.mgiDef = 2#魔法防御（每点代表16.6）
	atkEff = "atk_gongJian" #攻击时的特效
	evos = ["cex___al-executer-b2"]
	addSkill("每{cd}秒杀掉一名随机[非召唤]敌方单位(对塞壬则强制扣血15%)", "抹杀", "moSha", 18)
	addSkill("降低受到的50%普攻伤害", "模糊")
	if id == "cex___al-executer-b":
		addSkillTxt("[color=#C0C0C0]参加18场战斗后，将进化为传奇单位[/color]")
	
func levelUp():
	.levelUp()
	updateAtt()
	
func updateAtt():
	updateTmpAtt("maxHp", 200, false)
	updateTmpAtt("atk", 5, false)
	updateTmpAtt("mgiAtk", 5, false)
	if level == 20 and gSiren.sirenAwaken:
		call("awaken")
		updateTmpAtt("maxHp", 1500, false)
		updateTmpAtt("atk", 100, false)
		updateTmpAtt("mgiAtk", 100, false)
	upAtt()

func _onBattleStart():
	._onBattleStart()
	skFlag = 0
	skFlag2 = true
#普攻承伤系数	
var p1 = 0.5
func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		atkInfo.hurtVal *= p1

var skFlag = 0
var skFlag2 = true
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "moSha":
		moSha()

func moSha():
	var chas = getAllChas(1)
	chas.shuffle()
	for i in chas:
		if i.isSumm:continue
		var dmg = i.att.hp
		if i.get("type") == "BOSS":dmg = i.att.maxHp * 0.15 
		increDmgNum(dmg, "抹杀", i)
		i.forceHurtSelf(dmg)
		if isAwaken and sys.rndPer(20):
			moSha()
		break
		