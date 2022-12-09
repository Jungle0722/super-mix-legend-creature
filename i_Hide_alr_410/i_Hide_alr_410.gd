extends "../azurline_ctrl/BaseResearchItem.gd"
func init():
	.init()
	name = "[color=#DC143C][传说]410mm连装炮(三式弹)"
	att.atk = 200
	att.cd = 0.4
	info = "造成任意伤害均赋予对方4层<烧蚀><流血>\n每8秒对当前目标两格区域内的敌人造成[双攻*1]的真实伤害，对轻甲、舰载机额外造成3倍伤害"
var p = 1

func _connect():
	._connect()
	if masCha == null:return
	masCha.connect("onAtkChara",self,"onAtkChara")

func onAtkChara(atkInfo):
	atkInfo.hitCha.addBuff(utils.buffs.b_liuXue_r.new(4))
	atkInfo.hitCha.addBuff(utils.buffs.b_shaoShi.new(4))

var index = 0
func _upS():
	index += 1
	if index >= 8 and masCha.aiCha != null:
		index = 0
		for i in masCha.getCellChas(masCha.aiCha.cell, 2, 1):
			var dmg = masCha.att.atk+masCha.att.mgiAtk * p
			if i.get("armorType") == "轻型" or i.isSumm:dmg *= 3
			masCha.azurHurtChara(i, dmg, Chara.HurtType.REAL, Chara.AtkType.SKILL, "410mm连装炮")