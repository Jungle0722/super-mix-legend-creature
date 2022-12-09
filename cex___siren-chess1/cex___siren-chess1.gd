extends "../cex___siren/cex___siren.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」执棋者I型"   #角色的名称
	lv = 2             #等级的设置
	attCoe.maxHp = 10
	addSkillTxt("[翻山炮]-普攻对当前目标身后一排的所有单位造成[法强*1]的魔法伤害")
	evos = ["cex___siren-chess2"]
	
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		qx(atkInfo.hitCha)

func qx(cha):
	var eff:Eff = newEff("sk_feiZhan",sprcPos)
	eff._initFlyPos(position + (cha.position - position).normalized() * 800, 800)
	eff.connect("onInCell",self,"effInCell")

func effInCell(cell):
	var cha = matCha(cell)
	if cha != null && cha.team != team :
		azurHurtChara(cha, min(cha.att.maxHp*1.2, att.mgiAtk), Chara.HurtType.MGI, Chara.AtkType.SKILL, "翻山炮")