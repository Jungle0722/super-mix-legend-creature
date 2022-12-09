extends "../azurline_ctrl/BaseResearchItem.gd"
func init():
	.init()
	name = "[color=#DC143C][传说]相位裂解炮"
	att.mgiAtk = 200
	att.cd = 0.35
	att.mgiPenL = 0.5
	info = "每8秒对当前目标造成[法强*10]的技能伤害，并融化其装甲，使其装甲类型变为：残破(受到的伤害增加30%)"

var index = 0
func _upS():
	index += 1
	if index >= 8 and masCha.aiCha != null and not masCha.isDeath and not masCha.aiCha.isDeath:
		index = 0
		masCha.aiCha.setGunAndArmor(masCha.aiCha.gunType, "残破")
		masCha.azurHurtChara(masCha.aiCha, masCha.att.mgiAtk * 10, Chara.HurtType.MGI, Chara.AtkType.SKILL, "相位裂解炮")
