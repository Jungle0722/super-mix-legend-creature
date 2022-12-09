extends "../cazurlineC_2/cazurlineC_2.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「重巡」柴郡"
	attCoe.atkRan = 3  #攻击距离
	attCoe.maxHp += 3   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 4     #攻击力（每点代表8.5）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2     #物理防御（每点代表15）
	lv = 3
	isResearch = true
	p1 = 100
	autoGetSkill()

	addSkill("每{cd}秒弱驱散所有友军的负面状态", "暗中观察", "darkWatch", 7)
	addSkill("友军每使用一次技能，积攒1点能量，当能量达到15点时，进入<PowerUp>状态", "PowerUp")

	setCamp("皇家")
	evos = ["cex___alr-chester2"]
	canCopy = false
	supportSpecEvo = 2

func _castCdSkill(id):
	._castCdSkill(id)	
	if id == "darkWatch":
		darkWatch()
			
func darkWatch():
	var chas = getAllChas(2)
	for i in chas:
		for j in buffs:
			if j.isNegetive and j.get("dispel") != 2 and j.get("dispel") != 3:
				j.isDel = true

var power = 0
func _onCharaCastCdSkill(cha,id):
	._onCharaCastCdSkill(cha,id)
	if cha.team == team:
		power += 1
		var bf = hasBuff("b_powerUp")
		if power == 15 && bf == null:
			addBuff(b_powerUp.new())
		if isAwaken and power >= 10 and bf != null and skFlag <= 0:
			power = 0
			skFlag = 3
			for i in range(2):
				yield(reTimer(0.15),"timeout")
				if aiCha == null:
					yield(reTimer(0.05),"timeout")
				.normalAtkChara(aiCha)
		
var skFlag = 0
func _upS():
	._upS()
	skFlag -= 1

func _onBattleStart():
	._onBattleStart()
	skFlag = 0
	if upgraded:
		addBuff(b_powerUp.new())

func _onBattleEnd():
	._onBattleEnd()
	power = 0

class b_powerUp:
	extends Buff
	var buffName = "PowerUp"
	func _init():
		attInit()
		id = "b_powerUp"	
		att.atkR = 0.75
	func _connect():
		masCha.connect("onHurt",self,"_onHurt")
	func _onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 && not atkInfo.isMiss:
			atkInfo.hurtVal *= 0.7
	