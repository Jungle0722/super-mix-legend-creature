extends "../cazurlineE_6_2/cazurlineE_6_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」提康德罗加·改"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atk += 2
	attCoe.maxHp += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	addSkill("自身及自身舰载机造成普攻伤害时，若目标身上的流血层数大于18层，则该次伤害翻倍", "撕裂")
	addSkillTxt("[color=#C0C0C0][现代化改造]-流火之翼伤害提高150%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""
func upgrade():
	p3 = 1
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func castPlane():
	var cha = .castPlane()
	if cha != null:
		cha.addBuff(b_al_e621.new())

func _onBattleStart():
	._onBattleStart()		
	addBuff(b_al_e621.new())
	
class b_al_e621:
	extends Buff
	var buffName = "撕裂"
	var dispel = 2
	var buffUtil = globalData.infoDs["g_azurlineBuffs"]
	func _init():
		attInit()
		id = "b_al_e621"
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL:
			var bf = atkInfo.hitCha.hasBuff("b_liuXue_r")
			if bf != null and bf.life >= 18:
				atkInfo.hurtVal *= 2