extends "../cazurlineA_2/cazurlineA_2.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「驱逐」尼古拉斯"   #角色的名称
	attCoe.maxHp += 1
	lv = 3             #等级的设置
	evos = ["cazurlineA_2_2_1"]
	addSkill("造成伤害时附带3层<霜冻>，若目标身上霜冻层数大于10层，造成[法强*5%*层数]的真实伤害，清空层数", "霜刃")
	autoGetSkill()
	setCamp("白鹰")

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.EFF:return
	frostBlade(atkInfo.hitCha)

func frostBlade(cha):
	cha.addBuff(buffUtil.b_freeze.new(3))
	var buff = cha.hasBuff("b_freeze")
	if buff.life > 10:
		buff.isDel = true
		azurHurtChara(cha, att.mgiAtk * 0.05 * buff.life, Chara.HurtType.REAL, Chara.AtkType.EFF, "霜刃")