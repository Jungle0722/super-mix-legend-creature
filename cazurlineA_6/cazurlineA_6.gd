extends "../cazurlineA/cazurlineA.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」阿卡司塔"   #角色的名称
	attCoe.mgiAtk += 1  #魔法攻击（每点代表13.7）
	attCoe.atk += 1
	lv = 2             #等级的设置
	evos = ["cazurlineA_6_1"]
	addSkill("本回合友军彻底阵亡时，提高自身50法强", "义愤")
	setCamp("皇家")
	ename = "akasita"

func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha):return
	if cha.team == team:
		var mgiAtk = 50
		var buff = hasBuff("b_akasita")
		if buff == null:
			addBuff(b_akasita.new(mgiAtk))
		elif team == 1 || team == 2 && buff.att.mgiAtk < 500:
			buff.att.mgiAtk += mgiAtk

class b_akasita:
	extends Buff
	var buffName = "义愤"
	var dispel = 2
	func _init(mgiAtk):
		attInit()
		id = "b_akasita"	
		att.mgiAtk = mgiAtk

