extends "../cazurlineB_6_3/cazurlineB_6_3.gd"
func _info():
	pass
var baseId = ""
func _extInit():
	._extInit()
	chaName = "「轻巡」莱比锡·改"   #角色的名称
	attCoe.atk += 3     #攻击力（每点代表8.5）
	attCoe.maxHp += 1
	lv = 4             #等级的设置
	addSkill("<先手><固化><唯一>每8秒提高全体友军5%血上限并恢复5%血量", "防御指挥")

	addSkillTxt("[color=#C0C0C0][现代化改造]-防御指挥还将提高双防(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setGunAndArmor("中型","中型")

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var index = 8
func _upS():
	index += 1
	if index >= 8:
		index = 0
		for i in getAllChas(2):
			var bf = i.hasBuff("b_b631")
			if bf == null:
				i.addBuff(b_b631.new(0.5))
			else:
				bf.att.maxHpL += 0.05

			i.healCha(i, i.att.maxHp*0.05)
			if upgraded:
				i.addBuff(buffUtil.b_twoDefL.new(0.5))

			
func _onBattleEnd():
	._onBattleEnd()		
	index = 8

class b_b631:
	extends Buff
	var buffName = "百分比血上限"
	var dispel = 1
	func _init(num = 1.0, duration = 0, dispelable = true):
		attInit()
		id = "b_b631"	
		if num < 0:
			isNegetive = true
		att.maxHpL = 0.1 * num
		if duration > 0:
			life = duration
			lv = duration
		else:
			id += "_p"
		if dispelable: self.dispel = 2	