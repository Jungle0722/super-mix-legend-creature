extends "../azurline_ctrl/fighter.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战斗机」紫电改二"   #角色的名称
	attCoe.maxHp += 5   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 3
	attCoe.def += 3
	attCoe.mgiDef += 3
	lv = 4             #等级的设置
	addSkillTxt("受到普攻赋予攻击者3层<失明>")
	addSkillTxt("每次突进后嘲讽附近2格的目标并获得50%减伤，持续3秒")
	
var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "tujin":
		for cha in getCellChas(cell, 2, 1):
			cha.addBuff(buffUtil.b_taunt.new(6, self))
			cha.aiCha = self
		if hasBuff("b_ziDian") == null:
			addBuff(b_ziDian.new())

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		atkInfo.atkCha.addBuff(utils.buffs.b_blindness.new(3))

class b_ziDian:
	extends Buff
	func _init():
		attInit()
		id = "b_ziDian"
		life = 3
	func _connect():
		masCha.connect("onHurt",self,"_onHurt")
	func _onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 && not atkInfo.isMiss:
			atkInfo.hurtVal *= 0.5