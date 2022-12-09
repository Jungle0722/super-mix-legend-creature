extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」穗香"   #角色的名称
	attCoe.mgiAtk += 2  #魔法攻击（每点代表13.7）
	attCoe.mgiDef += 2
	attCoe.maxHp += 1
	attCoe.atkRan = 3
	lv = 3             #等级的设置
	evos = ["cex___alhide-honoka2"]
	canCopy = false
	addSkill("造成的所有伤害均会为血量最低的友军恢复[伤害量50%]的血量", "治疗协议")
	addSkill("所有敌人获得正面效果时有50%概率被弱驱散，并受到[效果层数*双攻*0.5]的物理技能伤害", "甜蜜陷阱")
	ename = "suixiang"
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("其他")

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.hurtVal < 10:return
	var cha = getFirstCha(2, "sortByHp")
	if cha != null:
		healCha(cha, atkInfo.hurtVal * 0.5)

func _upS():
	._upS()
	for i in getAllChas(1):
		if i.hasBuff("b_honoka") == null:
			i.addBuff(b_honoka.new(self))

class b_honoka:
	extends Buff
	var buffName = "甜蜜陷阱"
	var dispel = 2
	var cha
	func _init(cha):
		attInit()
		id = "b_honoka"
		self.cha = cha
	func _connect():
		masCha.connect("onAddBuff",self,"onAddBuff")
	func onAddBuff(buff):
		if sys.rndPer(50):return
		if not buff.isNegetive && buff.get("type") != config.EQUITYPE_EQUI && buff.get("dispel") != 2 and buff.get("dispel") != 3:
			var p = 0.5
			if cha.upgraded:p = 1.5
			cha.azurHurtChara(masCha, (cha.att.atk + cha.att.mgiAtk)*buff.life*p, Chara.HurtType.PHY, Chara.AtkType.SKILL, "甜蜜陷阱")
			buff.isDel = true