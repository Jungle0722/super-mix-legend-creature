extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」纪伊"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	attCoe.mgiAtk += 2
	lv = 3             #等级的设置
	evos = ["cex___als-kii2"]
	canCopy = false
	addSkill("对血量低于20%的敌人造成普攻伤害时，将其秒杀", "斩杀")
	addSkill("本回合内，每秒提高60点四维，上限1200", "英勇奋进")
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("重樱")

func _onBattleStart():
	._onBattleStart()
	if hasBuff("b_zhanSha") == null:
		addBuff(buffUtil.b_zhanSha.new())
	
func _upS():
	._upS()
	var buff = hasBuff("b_kii")
	if buff == null:
		addBuff(b_kii.new())
	elif buff.att.atk < 1200:
		buff.att.atk += 40
		buff.att.mgiAtk += 40
		buff.att.def += 40
		buff.att.mgiDef += 40

class b_kii:
	extends Buff
	var buffName = "英勇奋进"
	func _init():
		attInit()
		id = "b_kii"
		att.atk = 1
		att.mgiAtk = 1
		att.def = 1
		att.mgiDef = 1

