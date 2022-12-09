extends "../cazurlineA/cazurlineA.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「驱逐」萤火虫"   #角色的名称
	attCoe.mgiAtk += 1  #魔法攻击（每点代表13.7）
	attCoe.mgiDef += 1
	attCoe.def += 1
	lv = 2             #等级的设置
	evos = ["cazurlineA_1_1","cazurlineA_1_2","cazurlineA_1_3"]
	addSkill("每{cd}秒对当前目标发起无畏撞击，对敌我均造成[血上限10%]的魔法伤害(每100点法强+15%的对敌伤害系数)", "彗星头锤", "hxtc", 8)
	setCamp("皇家")
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="hxtc":
		hxtc()
var skNum = 0
func hxtc():
	var dmg = 0.1 + att.mgiAtk/1000.0 * 1.5
	dmg = min(2, dmg)
	if ename == "maoyin" and upgraded:
		dmg *= 1.35
	if skNum >= 2 and ename == "maoyin":
		utils.createSkillTextEff("夕星", position)
		skNum = 0
		for i in getAllChas(1):
			azurHurtChara(i, min(40000, i.att.maxHp)*dmg, Chara.HurtType.MGI, Chara.AtkType.SKILL, "彗星头锤")
	else:
		azurHurtChara(aiCha, min(40000, aiCha.att.maxHp)*dmg, Chara.HurtType.MGI, Chara.AtkType.SKILL, "彗星头锤")
	hurtChara(self, att.maxHp*0.1, Chara.HurtType.MGI, Chara.AtkType.EFF)
	skNum += 1
	
func _onBattleEnd():
	._onBattleEnd()	
	skNum = 0