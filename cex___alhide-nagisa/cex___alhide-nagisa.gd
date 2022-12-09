extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」凪咲"   #角色的名称
	attCoe.mgiAtk += 2  #魔法攻击（每点代表13.7）
	attCoe.mgiDef += 2
	attCoe.maxHp += 1
	attCoe.atkRan = 3
	lv = 3             #等级的设置
	evos = ["cex___alhide-nagisa2"]
	canCopy = false
	addSkill("战斗开始时向最近的敌人发射一枚飞弹，造成[目标血上限50%]的真实伤害，并向另一名\n				随机敌方单位弹射(每秒弹射一次，无限弹射循环到只剩一名敌人为止)", "链式反应")
	addSkill("<固化>每10秒弱驱散所有敌人，并清除掉敌人的护盾、圣盾", "太阳风暴")
	ename = "zhixiao"
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("其他")


var lastPosition
var lastCha
var lastAtk = true
func _upS():
	._upS()
	flag += 1
	if flag >= 10:
		flag = 0
		for i in getAllChas(1):
			if i.has_method("changeShield") and i.shield > 0:
				i.changeShield(-i.shield)
			weakDispel(i, false)

	if lastPosition == null:return
	var chas = getAllChas(1)
	chas.erase(lastCha)
	if chas.size() >= 1:
		chas.shuffle()
		var cha = chas.pop_back()
		createFlyEff(lastPosition, cha, "sk_4_1_2")
		azurHurtChara(cha, maxHp(cha)*0.2*difficult.difficult, Chara.HurtType.REAL, Chara.AtkType.SKILL, "链式反应")
		lastPosition = cha.sprcPos
		lastCha = cha
	else:
		if lastAtk and upgraded:
			azurHurtChara(aiCha, maxHp(aiCha)*1, Chara.HurtType.REAL, Chara.AtkType.SKILL, "链式反应")
			lastAtk = false


func _onBattleStart():
	._onBattleStart()
	yield(reTimer(0.1),"timeout")
	createFlyEff(sprcPos, aiCha, "sk_4_1_2")
	azurHurtChara(aiCha, maxHp(aiCha)*0.5, Chara.HurtType.REAL, Chara.AtkType.SKILL, "链式反应")
	lastPosition = aiCha.sprcPos
	lastCha = aiCha

func _onBattleEnd():
	._onBattleEnd()	
	lastPosition = null
	lastAtk = true
	flag = 0
	lastCha = null

var flag = 0
		