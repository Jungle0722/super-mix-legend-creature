extends "../cazurlineD_2_1/cazurlineD_2_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」厌战·誓约"   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	addSkill("击杀非召唤单位时，获得3金币，永久提高2点攻击(上限700)，并使该单位相邻的敌人<恐惧>2秒", "皇家传奇")

	addSkillTxt("[color=#C0C0C0][现代化改造]-击杀非召唤单位额外获得3PT(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")

var baseId = ""

func _onKillChara(atkInfo):
	._onKillChara(atkInfo)	
	if atkInfo.hitCha.isSumm:return
	sys.main.player.plusGold(3)
	if upgraded:
		azurCtrl.plusPt(3)
	if level < 350:
		updateTmpAtt("atk", 2)
	var chas = getCellChas(atkInfo.hitCha.cell, 2, 1)
	for i in chas:
		i.addBuff(buffUtil.b_twoSpd.new(-3, 2))

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")