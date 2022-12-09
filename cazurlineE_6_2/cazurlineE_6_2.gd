extends "../cazurlineE_6/cazurlineE_6.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」提康德罗加"   #角色的名称
	attCoe.maxHp += 2
	lv = 3             #等级的设置
	attCoe.atk += 2
	attCoe.mgiAtk -= 1
	evos = ["cazurlineE_6_2_1"]
	addSkill("自身及自身舰载机造成普攻伤害时附加目标4层<流血>且暴击时额外附加[攻击\n*目标流血层数*0.4]的物理特效伤害", "流火之翼")
	ename = "tikangdeluojia"
	autoGetSkill()
	camp = "白鹰"
var p3 = 0.4
func castPlane():
	var cha = .castPlane()
	if cha != null:
		cha.addBuff(b_al_e62.new(p3))
	return cha

func _onBattleStart():
	._onBattleStart()		
	addBuff(b_al_e62.new(p3))

class b_al_e62:
	extends Buff
	var buffName = "流火之翼"
	var dispel = 2
	var buffUtil = globalData.infoDs["g_azurlineBuffs"]
	var num = 0.2
	func _init(num = 0.2):
		attInit()
		id = "b_al_e62"
		self.num = 0.2
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL:
			atkInfo.hitCha.addBuff(buffUtil.b_liuXue_r.new(4))
			var bf = atkInfo.hitCha.hasBuff("b_liuXue_r")
			if bf != null and atkInfo.isCri:
				masCha.azurHurtChara(atkInfo.hitCha, masCha.att.atk*bf.life*num, Chara.HurtType.PHY, Chara.AtkType.EFF, "流火之翼")