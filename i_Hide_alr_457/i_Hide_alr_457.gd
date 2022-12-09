extends "../azurline_ctrl/BaseResearchItem.gd"
func init():
	.init()
	name = "[color=#DC143C][传说]试作型双联457mm主炮MkA"
	att.atk = 300
	att.spd = 1
	att.cd = 0.4
	att.penL = 0.4
	att.atkRan = 3
	att.suck = 0.4
	att.cri = 0.4
	info = "[color=#DC143C]装备者仅能装备这一件装备[/color]\n造成普攻伤害时能对目标身后三格的单位造成双倍普攻伤害"
		
func _connect():
	._connect()
	if masCha.id == "cex___al-merchant":return
	if masCha.get("tag") != "azurline":
		delFromCha()
		return
	masCha.connect("onAddItem",self,"onAddItem")
	masCha.connect("onAtkChara",self,"onAtkChara")

func onAtkChara(atkInfo):
	if atkInfo.hitCha.team == masCha.team or atkInfo.get("skill") == "试作型双联457mm" or not atkInfo.atkType == Chara.AtkType.NORMAL:
		return
	var mcha1 = masCha.matCha(masCha.aiCha.cell + Vector2(1, 0))
	var mcha2 = masCha.matCha(masCha.aiCha.cell + Vector2(2, 0))
	var mcha3 = masCha.matCha(masCha.aiCha.cell + Vector2(3, 0))
	if mcha1 != null && mcha1.team != masCha.team:
		masCha.azurHurtChara(mcha1, atkInfo.atkVal*2, Chara.HurtType.PHY, Chara.AtkType.NORMAL, "试作型双联457mm")
	if mcha2 != null && mcha2.team != masCha.team:
		masCha.azurHurtChara(mcha2, atkInfo.atkVal*2, Chara.HurtType.PHY, Chara.AtkType.NORMAL, "试作型双联457mm")
	if mcha3 != null && mcha3.team != masCha.team:
		masCha.azurHurtChara(mcha3, atkInfo.atkVal*2, Chara.HurtType.PHY, Chara.AtkType.NORMAL, "试作型双联457mm")

func onAddItem(item):
	yield(sys.get_tree().create_timer(0.4), "timeout")
	if masCha == null:return
	var index = masCha.items.size() - 1
	while index >= 0:
		if masCha.items[index].id != id:
			masCha.delItem(masCha.items[index])
		index -= 1
