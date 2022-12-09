extends "../cazurlineD_4_1/cazurlineD_4_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」黎塞留·誓约"   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 1
	attCoe.atk += 2
	addSkill("<固化><唯一><先手>每10秒对所有敌人造成12%血上限的真实伤害，并使其血上限降低8%(以初始血上限为准)", "爱丽丝之焰")

	addSkillTxt("[color=#C0C0C0][现代化改造]-爱丽丝之帜作用范围+1，每100点攻击提高爱丽丝之焰1%伤害系数(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

var flag = 0
func _upS():
	._upS()
	flag += 1
	if flag >= 10:
		aliceFlame()
		flag = 0

func aliceFlame():
	utils.createSkillTextEff("爱丽丝之焰", position)
	var chas = getAllChas(1)
	for i in chas:
		var buff = i.hasBuff("b_lsl_alszy")
		var dmg = min(0.5, 0.12 + att.atk/1000.0 * 0.1)
		if team == 1:
			azurHurtChara(i, i.att.maxHp*dmg, Chara.HurtType.REAL, Chara.AtkType.EFF, "爱丽丝之焰")
		else:
			azurHurtChara(i, i.att.maxHp*min(0.5, dmg), Chara.HurtType.PHY, Chara.AtkType.EFF, "爱丽丝之焰")
		if buff == null:
			i.addBuff(b_lsl_alszy.new())

func _onBattleStart():
	._onBattleStart()			
	aliceFlame()
		
class b_lsl_alszy:
	extends Buff
	var buffName = "爱丽丝之焰"
	var initHp
	var dispel = 2
	func _init():
		attInit()
		id = "b_lsl_alszy"	
		att.maxHpL = -0.08
	func incr():
		if masCha.team == 1:
			att.maxHpL -= 0.02
		else:
			att.maxHpL -= 0.08
	var index = 0
	func _upS():
		index += 1
		if index >= 10:
			index = 0
			incr()
		if masCha.att.hp < 0:
			masCha.hurtChara(masCha, 1, Chara.HurtType.REAL, Chara.AtkType.EFF)

func upgrade():
	p3 = 3
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")