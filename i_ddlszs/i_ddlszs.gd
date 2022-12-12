extends "../azurline_base_item/azurline_base_item.gd"

func init():
	.init()
	name = "代达罗斯之殇"
	att.atk = 120
	info = "普通攻击有15%的几率变为致命一击，造成200%伤害"


func _connect():
	masCha.connect("onAtkChara",self,"StrongAttack")

func StrongAttack(atkInfo:AtkInfo):
	if sys.rndPer(15) && atkInfo.atkType == Chara.AtkType.NORMAL:
		azurHurtChara(atkInfo.hitCha, atkInfo.hurtVal*2, Chara.HurtType.PHY, Chara.AtkType.EFF, "致命一击")