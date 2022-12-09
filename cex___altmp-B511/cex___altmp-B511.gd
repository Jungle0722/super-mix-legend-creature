extends "../cex___altmp-B51/cex___altmp-B51.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「轻巡」宁海"   #角色的名称
	attCoe.maxHp += 1
	attCoe.atk += 1
	isSumm = true
	lv = 4             #等级的设置
	addSkillTxt("[壮志难酬]-<亡语>死亡时随机召唤一名3级舰娘")
	setGunAndArmor("中型","中型")

var baseId = ""

func deathWord():
	.deathWord()
	summChara(sys.rndListItem(utils.lv3))
