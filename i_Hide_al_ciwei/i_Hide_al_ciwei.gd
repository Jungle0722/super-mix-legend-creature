extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]刺猬炮"
	att.cd = 0.5
	att.atk = 120
	att.mgiAtk = 120
	price = 300
	info = "每6秒对目标造成1点的6次技能伤害与6次普攻伤害\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可被科研装备吞噬[/color]"

var index = 0
func _upS():
	if masCha == null || not utils.inBattle(masCha):return
	index += 1
	if index >= 6 and masCha.aiCha != null:
		index = 0
		for i in range(6):
			yield(sys.get_tree().create_timer(0.02), "timeout")
			if masCha.aiCha == null or masCha.aiCha.isDeath:continue
			masCha.hurtChara(masCha.aiCha, 1, Chara.HurtType.REAL, Chara.AtkType.SKILL)
			masCha.hurtChara(masCha.aiCha, 1, Chara.HurtType.REAL, Chara.AtkType.NORMAL)
