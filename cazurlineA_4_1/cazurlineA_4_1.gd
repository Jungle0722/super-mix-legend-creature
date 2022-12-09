extends "../cazurlineA_4/cazurlineA_4.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「驱逐」夕立"   #角色的名称
	lv = 3             #等级的设置
	evos = ["cazurlineA_4_1_1"]
	addSkill("血量低于65%时，获得100%法强、暴击、冷却速度、法术吸血、爆伤", "所罗门狂犬")
	autoGetSkill()
	setCamp("重樱")

func _onBattleStart():
	._onBattleStart()
	addBuff(b_xl_slmkq.new())

class b_xl_slmkq:
	extends Buff
	var buffName = "所罗门狂犬"
	var dispel = 2
	func _init():
		attInit()
		id = "b_xl_slmkq"	
	func _upS():
		if masCha.att.hp/masCha.att.maxHp < 0.65 or masCha.upgraded:
			att.cd = 1
			att.cri = 1
			att.mgiAtk = 1
			att.mgiSuck = 1
			att.criR = 1
		else:
			att.cd = 0
			att.cri = 0
			att.mgiAtk = 0
			att.mgiSuck = 0
			att.criR = 0
		