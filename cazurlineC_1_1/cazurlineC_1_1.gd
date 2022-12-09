extends "../cazurlineC_1/cazurlineC_1.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「重巡」高雄"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attAdd.cri += 0.2
	attAdd.criR += 0.2
	lv = 3             #等级的设置
	addSkill("本场战斗内造成普攻伤害时会吸收该单位15%的四维、暴击、穿透、攻速属性为己用，每个角色只能吸一次", "武勋")
	addSkill("暴击爆伤+20%，暴击后获得1层<圣盾>", "威光")
	evos = ["cex___azurlineC"]
	autoGetSkill()
	setCamp("重樱")

var suckCha = []	
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == AtkType.NORMAL and not suckCha.has(atkInfo.hitCha) and not atkInfo.hitCha.isSumm:
		var cha = atkInfo.hitCha
		suckCha.append(cha)
		cha.addBuff(utils.buffs.b_wx_sub.new())
		var buff = hasBuff("b_gx_wuXun")
		if buff == null:
			addBuff(b_gx_wuXun.new(cha))
		else:
			buff.att.atk += cha.att.atk*0.15
			buff.att.mgiAtk += cha.att.mgiAtk*0.15
			buff.att.def += cha.att.def*0.15
			buff.att.mgiDef += cha.att.mgiDef*0.15
			buff.att.pen += cha.att.pen*0.15
			buff.att.cri += cha.att.cri*0.15
			buff.att.criR += cha.att.criR*0.15
			buff.att.penL += cha.att.penL*0.15
			buff.att.spd += cha.att.spd*0.15

	if atkInfo.atkType == AtkType.NORMAL and atkInfo.isCri and team == 1:
		buffUtil.addShengDun(self, p3)

func _onBattleEnd():
	._onBattleEnd()
	suckCha = []
	
class b_gx_wuXun:
	extends Buff
	var buffName = "武勋"
	var dispel = 2
	func _init(cha):
		attInit()
		id = "b_gx_wuXun"	
		att.atk += cha.att.atk*0.15
		att.mgiAtk += cha.att.mgiAtk*0.15
		att.def += cha.att.def*0.15
		att.mgiDef += cha.att.mgiDef*0.15
		att.pen += cha.att.pen*0.15
		att.cri += cha.att.cri*0.15
		att.criR += cha.att.criR*0.15
		att.penL += cha.att.penL*0.15
		att.spd += cha.att.spd*0.15

var p3 = 1