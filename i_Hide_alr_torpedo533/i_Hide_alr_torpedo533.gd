extends "../azurline_ctrl/BaseResearchItem.gd"
func init():
	.init()
	name = "[color=#DC143C][传说]五联装533mm磁性鱼雷"
	att.spd = 0.5
	att.cd = 0.5
	info = "[color=#DC143C]仅限非战列舰娘装备[/color]\n每次使用技能时，有35%几率发射一枚磁性鱼雷，对当前目标周围(十字范围)的所有敌人造成[目标血上限*0.5]的真实伤害"
var p2 = 0.5
	
func _connect():
	._connect()
	if masCha.id == "cex___al-merchant":return
	if masCha.get("type2") == "bb":
		delFromCha()
		return
	masCha.connect("onCastCdSkill",self,"onCastCdSkill")
func onCastCdSkill(id):
	if sys.rndPer(35):
		for i in masCha.getCellChas(masCha.aiCha.cell, 1, 1):
			masCha.azurHurtChara(i, min(40000, i.att.maxHp)*p2, Chara.HurtType.REAL, Chara.AtkType.SKILL, "五联装533mm磁性鱼雷")