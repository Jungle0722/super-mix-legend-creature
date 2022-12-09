extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「高级塞壬」构建者"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atkRan = 5  #攻击距离
	attCoe.maxHp = 80   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 10	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 6  #魔法攻击（每点代表13.7）
	attCoe.def = 5	#物理防御（每点代表15）
	attCoe.mgiDef = 5  #魔法防御（每点代表16.6）

	addSkill("开局随机获得3件装备，每{cd}秒召唤一名随机2级舰娘", "援军", "yj", 15)
	addSkill("每{cd}秒召唤一名随机1级塞壬", "强援", "qy", 15)
	addSkill("自身3格范围内的友军伤害提高20%，且有20%概率格挡所有伤害", "阵地构建")
	addSkill("每{cd}秒，使所有敌人造成[离自己距离*法强*0.2]的伤害", "坐标构建", "phbs", 10)
	addSkill("每{cd}秒弱驱散自身所有负面效果", "塞壬", "sr", 10)

	isHead = true

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="qy":
		qy()
	if id=="phbs":
		phbs()
	if id=="yj":
		yj()
	if id=="sr":
		sr()

func _upS():
	._upS()
	var chas = getCellChas(cell, 3, 2)
	for i in chas:
		if i.hasBuff("b_gjz_zdgj") == null:
			i.addBuff(b_gjz_zdgj.new())

func qy():
	if difficult.difficult < 6:
		summChara(sys.rndListItem(gSiren.leaders)%[1], false)
	else:
		summChara(sys.rndListItem(gSiren.leaders)%[2], false)

func phbs():
	utils.createSkillTextEff("坐标构建", position)
	var index = 0
	playEff(cell)
	var chas = getAllChas(1)
	chas.sort_custom(self, "sort")
	for i in chas:
		var r = cellRan(i.cell, cell)
		if r > 4:
			r = 4
		azurHurtChara(i, min(i.att.maxHp*1.2, r * att.mgiAtk * 0.2), Chara.HurtType.MGI, Chara.AtkType.SKILL, "坐标构建")
	
func playEff(cell):
	var eff = sys.newEff("animEff", sys.main.map.map_to_world(cell))
	eff.setImgs(direc + "eff/jiaodizha", 8, false)
	eff.scale *= 2
	eff.normalSpr.position=Vector2(0, -20)
	yield(reTimer(0.4),"timeout")
		
func yj():
	if difficult.difficult == 7:
		summChara(sys.rndListItem(utils.lv3), false)
	elif difficult.difficult > 4:
		summChara(sys.rndListItem(utils.lv3), false)
	else:
		summChara(sys.rndListItem(utils.lv2), false)

func _onBattleStart():
	._onBattleStart()
	addItem(sys.newItem(utils.getRandomItem("PHY")))
	addItem(sys.newItem(utils.getRandomItem("MGI")))
	addItem(sys.newItem(utils.getRandomItem("DEF")))

class b_gjz_zdgj:
	extends Buff
	func _init():
		attInit()
		id = "b_gjz_zdgj"	
		att.atkR = 0.2
	func _connect():
		masCha.connect("onHurt", self, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if sys.rndPer(20):
			atkInfo.hurtVal = 0
			
var flag2 = true
func _onDeath(atkInfo):
	._onDeath(atkInfo)
	if not flag2:return
	flag2 = false
	research.changeRData(40)
	var achiOther = base.getSetting("achiOther", [])
	if achiOther.has("hougongMaster"):
		sys.main.player.addItem(sys.newItem("i_Hide_al_loveRing"))
	sys.main.player.addItem(sys.newItem("i_Hide_al_oldu"))
