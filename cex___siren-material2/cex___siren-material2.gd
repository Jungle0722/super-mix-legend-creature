extends "../cex___siren/cex___siren.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」武装运输船"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atk = 20
	attCoe.mgiAtk = 10
	attCoe.atkRan = 10
	attCoe.maxHp -= 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def -= 1     #物理防御（每点代表15）
	attCoe.mgiDef -= 1 #魔法防御（每点代表16.6）
	addSkill("受到[非特效]伤害时，立即对当前目标发起一次普攻", "自卫")
	addSkill("造成普攻伤害时，赋予目标2层随机负面效果", "干扰")

	addSkill("开场60秒后将会脱离战斗，逃之夭夭", "逃跑")
	addSkill("被击败后，随机掉落一件普通装备，有较低概率掉落稀有装备", "满载")

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL and not atkInfo.hitCha.isDeath:
		buffUtil.addRndDebuff(self, atkInfo.hitCha, 2)

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkType != Chara.AtkType.EFF:
		.normalAtkChara(aiCha)

var index = 0
func _upS():
	._upS()
	aiOn = false
	index += 1
	if index >= 60:
		escape()

func escape():
	cflag = false
	forceHurtSelf(att.maxHp)
	
var cflag = true
func _onDeath(atkInfo):
	._onDeath(atkInfo)
	if cflag:
		if sys.rndPer(75):
			sys.main.player.addItem(utils.getRndItem())
		else:
			sys.main.player.addItem(sys.newItem(utils.getRandomItem("RARE")))
		cflag = false



