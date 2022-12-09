extends "../cex___al-hood/cex___al-hood.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」胡德·誓约"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5））
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("将自身的装备基础属性的[25%]加持给全体队友(含召唤物)，\n					无法叠加，基础属性包括双攻双防攻速暴击", "皇家战旗")
	addSkillTxt("[color=#C0C0C0][现代化改造]-皇家舰队的荣耀效果翻倍，移除致命缺陷(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	p3 = 12
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""
var attr
func _upS():
	._upS()	
	doSnzq()

func doSnzq():
	var ally = getAllChas(2)
	attr = BaseAttr.new(items)
	for i in ally:
		if not i.hasBuff("b_snzq"):
			i.addBuff(b_snzq.new(attr))

class b_snzq:
	extends Buff
	var buffName = "皇家战旗"
	func _init(attr:BaseAttr):
		attInit()
		id = "b_snzq"
		att.atk = attr.atk
		att.mgiAtk = attr.mgiAtk
		att.def = attr.def
		att.mgiDef = attr.mgiDef
		att.spd = attr.spd
		att.cri = attr.cri

class BaseAttr:
	var atk = 0
	var mgiAtk = 0
	var def = 0
	var mgiDef = 0
	var spd = 0
	var cri = 0
	var p = 0.25
	func _init(items):
		for i in items:
			atk += i.att.atk*p
			mgiAtk += i.att.mgiAtk*p
			def += i.att.def*p
			mgiDef += i.att.mgiDef*p
			spd += i.att.spd*p
			cri += i.att.cri*p
