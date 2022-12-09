extends "../cazurlineD_4_2/cazurlineD_4_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」威尔士亲王·誓约"   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 2
	addSkill("本回合每阵亡一名友军，伤害提高20%，上限200%", "复仇")
	
	addSkillTxt("[color=#C0C0C0][现代化改造]-被遗志效果牺牲的友军立即满血复活，并获得3秒<无敌>(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

	addSkillTxt("[color=#C0C0C0]目睹战友胡德又双叒叕被迫害，威尔士亲王可能会彻底的爆发...")	
	if isAwaken:
		awaken()
	
var baseId = ""

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if team == 1 and isAwaken:
		atkInfo.hurtVal = min(att.maxHp*0.3, atkInfo.hurtVal)

func awaken(msg = true):
	chaName = "「战列」威尔士亲王·觉醒"
	addSkill("单次所受伤害不超过血上限30%", "心智觉醒", null, null, skillStrs.size() - 1)
	addSkill("本回合[非召唤]友军阵亡时，提高自身100攻击、50%攻速、20%吸血", "爱丽丝之怒", null, null, skillStrs.size() - 5)
	addSkill("本回合每阵亡一名友军，伤害提高40%，上限400%", "复仇", null, null, skillStrs.size() - 3)
	p4_1 = 4
	p4_2 = 0.4
	if not isAwaken:
		sys.newBaseMsg("事件", "威尔士亲王已经获得了心智觉醒！")
	isAwaken = true

var p4_1 = 2
var p4_2 = 0.2
func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha):return
	if cha.team == team:
		var buff = hasBuff("b_wesqw_fc")
		if buff == null:
			addBuff(b_wesqw_fc.new())
		elif buff.att.atkR < p4_1:
			buff.att.atkR += p4_2
		
class b_wesqw_fc:
	extends Buff
	var buffName = "复仇"
	func _init():
		attInit()
		id = "b_wesqw_fc"	
		att.atkR = 0.2

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")