extends "../cazurlineB_1_1/cazurlineB_1_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」蒙彼利埃·改"   #角色的名称
	attCoe.atkRan = 4#攻击距离
	attCoe.maxHp += 3   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 2
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("<唯一>战斗开始时，使相邻(九宫格范围)的友军获得<强化水侦>", "水面侦听")

	addSkillTxt("[color=#C0C0C0][现代化改造]-水面侦听可对全部友军施放(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setCamp("白鹰")
var baseId = ""

func _onBattleStart():
	._onBattleStart()
	if not upgraded or team == 2:
		for i in aroundCells:
			var cha = matCha(cell+i)
			if cha != null && cha.team == team && not cha.hasBuff("b_hszf"):
				cha.addBuff(b_hszf.new(0.3, self))
	else:
		for i in getAllChas(2):
			if not i.hasBuff("b_hszf"):
				i.addBuff(b_hszf.new(0.3, self))

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

class b_hszf:
	extends Buff
	var buffName = "强化水侦"
	var cha = null
	var p = 0.25
	func _init(p = 0.25, cha = null):
		attInit()
		id = "b_hszf"
		self.p = p
		self.cha = cha
	func _connect():
		masCha.connect("onHurt",self,"_onHurt")
	func _onHurt(atkInfo):
		if atkInfo.atkType == Chara.AtkType.SKILL && atkInfo.atkCha != masCha:
			var num = atkInfo.hurtVal*p
			if masCha.team == 2:
				num = min(atkInfo.atkCha.att.maxHp, num)
				num *= 0.5
			cha.azurHurtChara(atkInfo.atkCha, num, atkInfo.hurtType, Chara.AtkType.EFF, "水面侦听")
			atkInfo.hurtVal *= (1-p)
			for j in atkInfo.atkCha.skills:
				j.nowTime-=1