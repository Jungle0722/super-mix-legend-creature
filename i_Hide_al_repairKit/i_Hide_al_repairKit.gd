extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]维修工具"
	att.maxHp = 500
	att.maxHpL = 0.2
	price = 300
	info = "每秒恢复自身[血上限5%]的生命值\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可以被科研装备吞噬[/color]"

func _upS():
	if masCha == null || not utils.inBattle(masCha):return
	if masCha.get("tag") == "azurline":
		masCha.healCha(masCha, masCha.att.maxHp * 0.05)
	else:
		masCha.plusHp(masCha.att.maxHp * 0.05)
	

