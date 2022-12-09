extends "../cex___alhide-monica/cex___alhide-monica.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」莫妮卡·改"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("<固化>战斗开始20秒后，对所有点数低于莫妮卡的敌人造成[目标血上限95%]的神圣伤害\n			(对塞壬则强制扣除25%血量)，并使点数高于莫妮卡的敌人损失20%血量与血上限", "摊牌")

	addSkillTxt("[color=#C0C0C0][现代化改造]-roll点时点数+15，装备赌神的骰子时，点数额外+5(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

var flag = 0
func _upS():
	._upS()
	flag += 1
	if flag >= 20:
		tanPai()
		flag = 0

func tanPai():
	utils.createSkillTextEff("摊牌", position)
	for i in enemy:
		var cha = i.cha
		if cha.isDeath:return
		if i.num < point:
			if cha.get("type") == "BOSS":
				i.cha.forceHurtSelf(cha.att.maxHp*0.25)
				increDmgNum(cha.att.maxHp*0.25, "摊牌", cha)
			else:
				cha.forceHurtSelf(cha.att.maxHp*0.95)
				increDmgNum(cha.att.maxHp*0.95, "摊牌", cha)
				hurtChara(cha, 1, Chara.HurtType.REAL, Chara.AtkType.EFF)
		else:
			if cha.get("type") == "BOSS":
				cha.forceHurtSelf(cha.att.maxHp*0.2)
				cha.attAdd.maxHpL -= 0.2
				increDmgNum(cha.att.maxHp*0.2, "摊牌", cha)
			else:
				azurHurtChara(cha, cha.att.maxHp*0.2, Chara.HurtType.REAL, Chara.AtkType.EFF, "摊牌")
				cha.attAdd.maxHpL -= 0.2
			cha.upAtt()
			createCustEff(i.position, "eff/zhongDu", 10, false, 1.2, Vector2(0, -20))
		
func _onBattleEnd():
	._onBattleEnd()
	flag = 0