extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]FI-282直升机"
	info = "每秒对当前目标造成[攻击*1]的可暴击物理普攻伤害\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可以被科研装备吞噬[/color]"
	price = 300
	att.atk = 150
	att.penL = 0.3
	att.cri = 0.3
	att.penL = 0.15
	
func _upS():
	if masCha == null or not utils.inBattle(masCha) or masCha.aiCha == null:return
	var p2 = 1
	if masCha.isSumm:p2 = 0.5
	if masCha.get("tag") == "azurline":
		masCha.azurHurtChara(masCha.aiCha, masCha.att.atk*p2, Chara.HurtType.PHY, Chara.AtkType.NORMAL, "FI-282直升机", true)
	else:
		masCha.hurtChara(masCha.aiCha, masCha.att.atk*p2, Chara.HurtType.PHY, Chara.AtkType.NORMAL)





