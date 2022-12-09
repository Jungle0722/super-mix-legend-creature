extends "../azurline_ctrl/CAS.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轰炸机」实验型XSB3C-1"   #角色的名称
	attCoe.atk += 3
	attAdd.pen += 200
	attAdd.suck += 0.35
	lv = 4             #等级的设置
	addSkillTxt("每5秒立即对当前目标发起3次普攻")
	addSkillTxt("每普攻10次，自身进入<狂化>状态，持续3秒")
	addSkillTxt("当自身处于狂化状态时，免疫所有负面状态，暴击爆伤提高100%")
	addCdSkill("XSB3C", 5)

var baseId = ""
var atkNum = 0
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "XSB3C":
		if aiCha != null:
			.normalAtkChara(aiCha)
			.normalAtkChara(aiCha)
			.normalAtkChara(aiCha)

func _onNormalAtk(cha):
	._onNormalAtk(cha)
	atkNum += 1
	if atkNum >= 10 and hasBuff("b_XSB3C") == null:
		addBuff(b_XSB3C.new())

class b_XSB3C:
	extends Buff
	var dispel = 2
	func _init(lv = 1):
		attInit()
		id = "b_XSB3C"
		life = lv
		att.spd = 2
		att.cri = 1
		att.criR = 1

	func _connect():
		masCha.connect("onAddBuff",self,"onAddBuff")
	func onAddBuff(buff):
		if buff.isNegetive:
			buff.isDel = true