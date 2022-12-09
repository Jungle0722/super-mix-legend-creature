const Utils = globalData.infoDs["g_aDotaProcess"]
# Negetive Buffs:
class Buff_ArmorDefuseValue extends Buff:
	func _init(Value,Life=0):
		attInit()
		att.def -= Value
		effId = "p_liuXue"
		if Life > 0:
			life = Life
		id = "Buff_ArmorDefusedValue"
		isNegetive=true
	
class Buff_ArmorDefuseRate extends Buff:
	func _init(Origin,Rate,Life=0):
		attInit()
		att.def -= Origin * (Rate/100)
		effId = "p_liuXue"
		if Life > 0:
			life = Life
		id = "Buff_ArmorDefusedRate"
		isNegetive=true

class Buff_AtkDefuse extends Buff:
	func _init(Value,Life=0):
		attInit()
		att.atk -= Value
		effId = "p_liuXue"
		if Life > 0:life = Life

		id = "Buff_AtkDefuse"
		isNegetive=true

class Buff_DamageGiven extends Buff:
	var SourceChara
	var DamageValue
	var BuffHurtType
	var BuffAtkType
	func _init(AttackingChara ,Value, HurtType, AtkType=Chara.AtkType.EFF, Life=0):
		attInit()
		effId = "p_liuXue"
		id = "Buff_DamageGiven"
		if Life > 0:life = Life
		SourceChara = AttackingChara
		DamageValue = Value
		BuffHurtType = HurtType
		BuffAtkType = AtkType
	
	func _upS():
		SourceChara.hurtChara(masCha, DamageValue, BuffHurtType, BuffAtkType)

class Buff_AtkSpeedDefuse extends Buff:
	func _init(Value,Life=0):
		attInit()
		att.spd -= Value
		effId = "p_liuXue"
		if Life > 0:
			life = Life
		id = "Buff_AtkSpeedDefuse"
		isNegetive=true


#Race Buff:
enum {POWER, AGILITY, INTELLIGENCE}

class Buff_Talnet extends Buff:
	var Type = 0 # 英雄类型
	# 力量英雄在攻击时造成基于自己最大生命值的额外伤害
	# 敏捷英雄的攻击速度基于攻击力获得加成
	# 智力英雄攻击会烧灼目标，每秒造成法术攻击力的40%的魔法伤害,持续3秒
	func _init(argType):
		attInit()
		effId = "p_liuXue"
		id = "Buff_Talnet"
		Type = argType
		isNegetive=false
	
	func _connect():
		masCha.connect("onAtkChara",self,"OnAttack")
	
	func _upS():
		
		if Type == AGILITY:
			att.spd = (masCha.att.atk * 0.2)*0.01
			masCha.upAtt()
	
	func OnAttack(atkInfo):
		if Type == POWER && atkInfo.atkType == Chara.AtkType.NORMAL:
			masCha.hurtChara(atkInfo.hitCha,masCha.att.maxHp*0.1,Chara.HurtType.PHY,Chara.AtkType.EFF)
		if Type == INTELLIGENCE && atkInfo.atkType == Chara.AtkType.NORMAL:
			atkInfo.hitCha.addBuff(Buff_DamageGiven.new(masCha,masCha.att.att.mgiAtk*0.4,Chara.HurtType.MGI,Chara.AtkType.EFF,3))


# Control Buff:
class Buff_Stun extends Buff:
	var Effect
	var BeenProcessed = false
	func _init(Life = 3):
		attInit()
		id = "Buff_Stun"
		life = Life
		isNegetive=true

	func _connect():
		sys.main.connect("onCharaDel",self,"EffectRemove")
		connect("onSetCha",self,"_onSetCha")
		Effect = Utils.Effect_CreateAoe("Stun",masCha.position, Vector2(0,-50), 0, 1, true)

	func _onSetCha():
		masCha.aiOn = false
	
	func _del():
		masCha.aiOn = true
		if BeenProcessed == false:
			Effect.queue_free()
			BeenProcessed = true
	
	func EffectRemove(cha):
		if cha == masCha:
			if BeenProcessed == false:
				Effect.queue_free()
				BeenProcessed = true
