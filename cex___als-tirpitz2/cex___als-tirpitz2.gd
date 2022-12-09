extends "../cex___als-tirpitz/cex___als-tirpitz.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」提尔比茨·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("战斗开始时，获得[血上限*15%]({damage})的攻击", "存在舰队学说")

	addSkillTxt("[color=#C0C0C0][现代化改造]-战略威慑伤害系数+10(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	p3 = 20
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onBattleStart():
	._onBattleStart()
	addBuff(b_tirpitz3.new(att.maxHp*0.15))

class b_tirpitz3:
	extends Buff
	var buffName = "存在舰队学说"
	func _init(atk = 0):
		attInit()
		id = "b_tirpitz3"	
		att.atk = atk
