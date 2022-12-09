extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」新泽西"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2
	attCoe.def += 2
	attCoe.mgiDef += 2
	attCoe.atkRan = 4
	lv = 3             #等级的设置
	evos = ["cex___als-newJersey2"]
	addSkill("<唯一>使场上的敌方塞壬额外受到30%伤害，自身所受来自塞壬的伤害减少50%", "塞壬猎手")
	addSkill("持续嘲讽所有敌方塞壬，受到来自塞壬的伤害时，立即还以一次普攻，并恢复10%血量", "强强对决")
	ename = "xinzexi"
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("白鹰")
	canCopy = false

func _onBattleEnd():
	._onBattleEnd()
	skIndex = 3

var skIndex = 3
func _upS():
	._upS()
	skIndex += 1
	if skIndex >= 3:
		skIndex = 0
		for i in getAllChas(1):
			if i.get("type") == "BOSS" and i.hasBuff("b_newJersey") == null:
				i.addBuff(b_newJersey.new())
				var bf = i.hasBuff("b_taunt")
				if bf != null:bf.isDel = true
				i.addBuff(buffUtil.b_taunt.new(3, self))
				i.aiCha = self


func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkCha.get("type") == "BOSS":
		atkInfo.hurtVal *= 0.5
		.normalAtkChara(atkInfo.atkCha)
		healCha(self, att.maxHp * 0.1)

class b_newJersey:
	extends Buff
	var buffName = "塞壬猎手"
	var dispel = 2
	func _init():
		attInit()
		id = "b_newJersey"
		life = 3
		isNegetive = true
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0:
			atkInfo.factor += 0.3