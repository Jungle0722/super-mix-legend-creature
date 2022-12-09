extends "../cazurlineA/cazurlineA.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」时雨"   #角色的名称
	attCoe.mgiAtk += 1  #魔法攻击（每点代表13.7）
	attCoe.maxHp += 5
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 2             #等级的设置
	evos = ["cazurlineA_4_1", "cazurlineA_4_2"]
	addSkill("开局损失50%血量，每次使用技能，损失20%血量，额外造成[本回合已损失血量*1]\n			(不超过血上限200%)的魔法伤害", "血怒")
	setCamp("重樱")
var totalHurt = 0
#血怒伤害加成
var p2 = 1
func _onBattleStart():
	._onBattleStart()
	forceHurtSelf(att.hp*0.5)
	if team == 1:
		totalHurt += att.hp*0.5

func _onBattleEnd():
	._onBattleEnd()
	totalHurt = 0
func _onHurtEnd(atkInfo):
	._onHurtEnd(atkInfo)
	totalHurt += atkInfo.hurtVal

func _castCdSkill(id):
	._castCdSkill(id)
	if att.hp/att.maxHp > 0.2:
		forceHurtSelf(att.maxHp*0.2)
		totalHurt += att.maxHp*0.2
	if aiCha != null:
		azurHurtChara(aiCha, min(att.maxHp*2, totalHurt*p2), Chara.HurtType.MGI, Chara.AtkType.SKILL, "血怒")
		if id == "cazurlineA_4_1_1" and isAwaken:
			for i in getCellChas(aiCha.cell, 2, 1):
				if i != aiCha:
					azurHurtChara(i, min(att.maxHp*2, totalHurt*p2), Chara.HurtType.MGI, Chara.AtkType.SKILL, "血怒")