extends "../cex___siren/cex___siren.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「塞壬」物资船"   #角色的名称
	lv = 3             #等级的设置
	attCoe.atk = 0
	attCoe.mgiAtk = 0
	attAdd.spd = -10
	attCoe.atkRan = 5
	attCoe.maxHp -= 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def -= 2     #物理防御（每点代表15）
	attCoe.mgiDef -= 2 #魔法防御（每点代表16.6）
	addSkillTxt("[逃跑]-开场60秒后将会脱离战斗，逃之夭夭")
	addSkillTxt("[满载]-被击败后，随机掉落一件普通装备，有较低概率掉落稀有装备")
	aiOn = false

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



