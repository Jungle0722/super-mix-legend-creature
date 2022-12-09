extends "../cazurlineD_5_1/cazurlineD_5_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」英王乔治五世·改"   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 1
	addSkill("战斗开始时，将所有被连接成员的装备基础属性加成到自己身上(基础属性包括四维攻速物穿暴击爆伤)", "最适化武装")

	addSkillTxt("[color=#C0C0C0][现代化改造]-被链接成员提高属性的速度翻倍(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onBattleStart():
	._onBattleStart()
	yield(reTimer(0.2),"timeout")
	var attr = BaseAttr.new()
	for i in connChas:
		attr.refresh(i.items)
	addBuff(b_zshwz.new(attr))

class b_zshwz:
	extends Buff
	var buffName = "最适化武装"
	var dispel = 2
	func _init(attr:BaseAttr):
		attInit()
		id = "b_zshwz"
		att.atk = attr.atk
		att.mgiAtk = attr.mgiAtk
		att.def = attr.def
		att.mgiDef = attr.mgiDef
		att.spd = attr.spd
		att.criR = attr.criR
		att.cri = attr.cri
		att.penL = attr.penL

class BaseAttr:
	var atk = 0
	var mgiAtk = 0
	var def = 0
	var mgiDef = 0
	var spd = 0
	var criR = 0
	var cri = 0
	var penL = 0
	var p = 1
	func refresh(items):
		for i in items:
			atk += i.att.atk*p
			mgiAtk += i.att.mgiAtk*p
			def += i.att.def*p
			mgiDef += i.att.mgiDef*p
			spd += i.att.spd*p
			criR += i.att.criR*p
			cri = i.att.cri*p
			penL = i.att.penL*p
	func _init():
		pass

func upgrade():
	p3 = 30
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")