extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]随机单词生成器"
	info = "造成物理伤害时，将其转化为魔法伤害\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#DC143C]与可塑性机械臂互斥"
	price = 300
	att.atk = 200
	att.spd = 0.3
	att.mgiPenL = 0.3
	
func _connect():
	._connect()
	for i in masCha.items:
		if i.id == "i_Hide_al_adjustableArm":
			delFromCha()
			return
	masCha.connect("onAtkInfo", self, "onAtkInfo")

func onAtkInfo(atkInfo):
	if atkInfo.hurtType == Chara.HurtType.PHY:
		atkInfo.hurtType = Chara.HurtType.MGI