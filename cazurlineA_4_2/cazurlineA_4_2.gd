extends "../cazurlineA_4/cazurlineA_4.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「驱逐」Z46"   #角色的名称
	attCoe.maxHp += 2
	lv = 3             #等级的设置
	evos = ["cazurlineA_4_2_1"]
	addSkill("每{cd}秒对当前目标周围2格的敌人发射震荡波，造成[法强*2]({damage})的可暴击魔法伤害，每道震荡波会向周围(九宫格范围)\n				进行弹射，造成等额伤害", "回音击", "echoAtk", 7)
	autoGetSkill()
	setCamp("铁血")
var p3 = 2
var czdFlag = false
func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkType == Chara.AtkType.SKILL:
		atkInfo.hurtVal *= 0.5
	
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="echoAtk" and aiCha != null:
		echoAtk(aiCha)

func echoAtk(cha = aiCha):
	var dmg = att.mgiAtk*p3
	if czdFlag:
		dmg += min(40000, att.maxHp)*0.1
	for i in getCellChas(cha.cell, 2, 1):
		azurHurtChara(i, dmg, Chara.HurtType.MGI, Chara.AtkType.SKILL, "回音击", true)
		for j in getAroundChas(i.cell, false):
			if j == i:continue
			azurHurtChara(i, dmg, Chara.HurtType.MGI, Chara.AtkType.SKILL, "回音击", true)

func _onBattleStart():
	._onBattleStart()
	if difficult.difficult >= 5 and difficult.step > 50 and team == 2:
		addItem(sys.newItem("i_azurline_czd"))