extends "../cazurlineB_3/cazurlineB_3.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「轻巡」能代"   #角色的名称
	attCoe.maxHp += 2
	attCoe.mgiDef += 2
	attCoe.def += 1
	lv = 3             #等级的设置
	evos = ["cazurlineB_3_1_1"]
	addSkill("将溢出的闪避转化为伤害加成，本回合内，每次闪避成功，提高3%暴击、攻击、吸血、双防(上限120%)", "从容指顾")
	autoGetSkill()
	setCamp("重樱")
	setGunAndArmor("小型","超重型")
	
func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.isMiss:
		missNum += 1
		var buff = hasBuff("b_nd_xrzr")
		if buff == null:
			buff = addBuff(b_nd_xrzr.new())
			if isAwaken:
				buff.att.cri += 0.6
				buff.att.suck += 0.6
				buff.att.atkL += 0.6
				buff.att.defL += 0.6	
				buff.att.mgiDefL += 0.6
		elif buff.att.cri < 1.2:
			buff.att.cri += 0.03
			buff.att.suck += 0.03
			buff.att.atkL += 0.03
			buff.att.defL += 0.03	
			buff.att.mgiDefL += 0.03
			
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if att.dod > 1:
		atkInfo.hurtVal *= att.dod

class b_nd_xrzr:
	extends Buff
	var buffName = "从容指顾"
	func _init():
		attInit()
		id = "b_nd_xrzr"	
		att.cri = 0.03
		att.suck = 0.03
		att.atkL = 0.03	
		att.defL = 0.03
		att.mgiDefL = 0.03