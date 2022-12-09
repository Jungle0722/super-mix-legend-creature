extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]巫毒人偶"
	info = "造成法术伤害时，强驱散佩戴者当前普攻目标的所有增益效果\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可被科研装备吞噬"
	price = 300
	att.mgiAtk = 200
	att.cd = 0.3
	att.mgiPenL = 0.3
	
func _connect():
	._connect()
	masCha.connect("onAtkChara",self,"onAtkChara")

func onAtkChara(atkInfo):
	if masCha.aiCha == null or atkInfo.hurtType != Chara.HurtType.MGI or atkInfo.hitCha.team == atkInfo.atkCha.team:return
	for j in masCha.aiCha.buffs:
		if not j.isNegetive && j.get("type") != config.EQUITYPE_EQUI:
			j.isDel = true



