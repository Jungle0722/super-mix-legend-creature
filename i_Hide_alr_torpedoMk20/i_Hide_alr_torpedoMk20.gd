extends "../azurline_ctrl/BaseResearchItem.gd"
func init():
	.init()
	name = "[color=#DC143C][传说]潜艇用Mark20S鱼雷"
	att.mgiAtk = 200
	att.cd = 0.8
	info = "[color=#DC143C]仅限潜艇舰娘装备[/color]\n造成6次技能伤害后，发射一条鱼雷，对直线上的所有敌人造成[法强*2]的真实伤害"
var p2 = 2

func _connect():
	._connect()
	if masCha.id == "cex___al-merchant":return
	if masCha.get("type2") != "ss":
		delFromCha()
		return
	masCha.connect("onAtkChara",self,"run")
var index = 0
func run(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.SKILL and atkInfo.hitCha.team != atkInfo.atkCha.team: 
		index += 1
		if index >= 6 and masCha.aiCha != null:
			index = 0
			var eff:Eff = masCha.newEff("sk_chuanTouJian", masCha.sprcPos)
			eff._initFlyPos(masCha.position + (masCha.aiCha.position - masCha.position).normalized() * 1000, 250)
			eff.connect("onInCell",self,"effInCell")

func effInCell(cell):
	var cha = masCha.matCha(cell)
	if cha == null:
		cha = masCha.matCha(cell + Vector2(0, 1))
	if cha != null && cha.team != masCha.team:
		masCha.azurHurtChara(cha, masCha.att.mgiAtk*p2, Chara.HurtType.REAL, Chara.AtkType.EFF, "潜艇用Mark20S鱼雷")