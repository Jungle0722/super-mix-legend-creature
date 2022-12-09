extends "../cazurlineC_4/cazurlineC_4.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「重巡」扎拉"   #角色的名称
	attCoe.atk += 1     #物理防御（每点代表15）
	attCoe.maxHp += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cazurlineC_4_1_1"]
	addSkill("本回合内，每次普攻提高自身5%暴击、爆伤、吸血、攻击(上限300%)", "主炮校正")

	autoGetSkill()
	setCamp("铁血")
var p3 = 3
func _onNormalAtk(cha):
	if not is_instance_valid(cha):return
	._onNormalAtk(cha)
	if not is_instance_valid(cha):return
	var buff = hasBuff("b_zl_zpjz")
	if buff == null:
		buff = addBuff(b_zl_zpjz.new())
		if isAwaken:
			buff.att.cri += 0.7
			buff.att.criR += 0.7
			buff.att.suck += 0.7	
			buff.att.atkL += 0.7
	elif buff.att.cri < p3:
		buff.att.cri += 0.05
		buff.att.criR += 0.05
		buff.att.suck += 0.05	
		buff.att.atkL += 0.05

class b_zl_zpjz:
	extends Buff
	var buffName = "主炮校正"
	func _init():
		attInit()
		id = "b_zl_zpjz"	
		att.cri = 0.05
		att.criR = 0.05
		att.suck = 0.05
		att.atkL = 0.05