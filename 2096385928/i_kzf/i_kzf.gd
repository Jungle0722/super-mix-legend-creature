extends Item
func init():
	name = "狂战斧"
	type = config.EQUITYPE_EQUI
	attInit()
	att.atk = 60
	att.spd = 0.3
	info = "攻击目标时会溅射到其附近2格的敌方单位，造成30%伤害"

func _connect():
	masCha.connect("onAtkChara",self,"Attack")

func Attack(atkInfo:AtkInfo):
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		for i in masCha.getCellChas(atkInfo.hitCha.cell,2,1):
			if i != atkInfo.hitCha:
				fx(i,atkInfo)

func fx(Cha,atkInfo):
	var d:Eff = atkInfo.hitCha.newEff("atk_dang",atkInfo.hitCha.sprcPos)
	d._initFlyCha(Cha)
	yield(d,"onReach")
	if sys.isClass(Cha,"Chara"):
		masCha.hurtChara(Cha,atkInfo.hurtVal * 0.3,Chara.HurtType.PHY,Chara.AtkType.EFF)