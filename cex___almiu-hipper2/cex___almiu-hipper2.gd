extends "../cex___almiu-hipper/cex___almiu-hipper.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」希佩尔·μ兵装"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 1     #攻击力（每点代表8.5））
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("死战效果期间，每击杀10人，再次嘲讽周围3格的敌人并获得4层<死战>", "兵装解放")
	addSkillTxt(jbText)
	addSkillTxt("[color=#C0C0C0][现代化改造]-玉石俱焚伤害提高[μ兵装舰娘人数*20%](未解锁)")
	if isInManual():
		addSkillTxt("[color=#C0C0C0][兵装解放强化]-Lv1：触发阈值-2人，Lv2：触发阈值-5人")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""
	
func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL and sys.rndPer(p4):
		azurHurtChara(atkInfo.atkCha, atkInfo.atkVal, Chara.HurtType.PHY, Chara.AtkType.EFF, "兵装解放")

func _onKillChara(atkInfo):
	._onKillChara(atkInfo)
	if atkInfo.hitCha.isSumm:return
	kn += 1
	var bf = hasBuff("b_hipper")
	if bf != null:
		bf.life += 1
		if kn >= 10:
			kn = 0
			bf.life += 4
			var chas = getCellChas(cell, 3, 1)
			for i in chas:
				i.addBuff(buffUtil.b_taunt.new(4, self))
				i.aiCha = self