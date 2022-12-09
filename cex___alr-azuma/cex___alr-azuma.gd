extends "../cazurlineC_2/cazurlineC_2.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「重巡」吾妻"
	attCoe.atkRan = 3  #攻击距离
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 4     #攻击力（每点代表8.5）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2     #物理防御（每点代表15）
	lv = 3
	isResearch = true
	autoGetSkill()

	addSkill("每攻击或受伤15次，进入<狂化>状态，持续3秒", "怒火连峰")
	addSkill("每{cd}秒对当前目标造成[已造成伤害*4]的物理伤害，并清空累计值", "战斗本能", "combatInstinct", 6)
	
	setCamp("重樱")
	evos = ["cex___alr-azuma2"]
	canCopy = false
	supportSpecEvo = 2
var p4 = 15
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "combatInstinct":
		combatInstinct()

var damageNum = 0
var angryNum = 0
func combatInstinct():
	if aiCha != null:
		azurHurtChara(aiCha, damageNum*4, Chara.HurtType.PHY, Chara.AtkType.SKILL, "战斗本能")
		if not isAwaken:
			damageNum = 0
		else:
			damageNum *= 0.6
	
func _onNormalAtk(cha):
	._onNormalAtk(cha)
	angryNum += 1
	nhlf()

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	damageNum += atkInfo.hurtVal

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	angryNum += 1
	nhlf()

func nhlf():
	if angryNum >= p4:
		var buff = hasBuff("b_spd")
		if buff == null:
			addBuff(buffUtil.b_spd.new(20, 3))
		else:
			if buff.life != null:
				buff.life += 4
		angryNum = 0

func _onBattleEnd():
	._onBattleEnd()
	damageNum = 0
	angryNum = 0
	