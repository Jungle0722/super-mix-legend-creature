extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」英勇"   #角色的名称
	attCoe.atkRan = 3  #攻击距离
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	lv = 2             #等级的设置
	evos = ["cazurlineD_4_1", "cazurlineD_4_2"]
	addSkill("本回合[非召唤]友军彻底阵亡时，提高自身50攻击、30%攻速", "爱丽丝之怒")

	setCamp("皇家")

func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha):return
	if cha.team == team and not cha.isSumm:
		var atk = 50
		var suck = 0
		if isAwaken:
			atk *= 2
			suck = 0.2
		var spd = 0.3
		var buff = hasBuff("b_yy_alszn")
		if buff == null:
			addBuff(b_yy_alszn.new(atk, spd, suck))
		elif team == 1 || team == 2 && buff.att.atk < 250:
			buff.att.atk += atk
			buff.att.spd += spd
			buff.att.suck += suck

class b_yy_alszn:
	extends Buff
	var buffName = "爱丽丝之怒"
	var dispel = 2
	func _init(atk, spd, suck):
		attInit()
		id = "b_yy_alszn"	
		att.atk = atk
		att.spd = spd
		att.suck = suck

