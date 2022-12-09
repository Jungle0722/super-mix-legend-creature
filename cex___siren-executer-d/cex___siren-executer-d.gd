extends "../azurline_ctrl/SirenHead.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「高级塞壬」代行者·XIV"   #角色的名称
	lv = 4             #等级的设置
	attCoe.atkRan = 5  #攻击距离
	attCoe.maxHp = 200   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 21	 #攻击力（每点代表8.5）
	attCoe.mgiAtk = 21  #魔法攻击（每点代表13.7）
	attCoe.def = 6	#物理防御（每点代表15）
	attCoe.mgiDef = 6  #魔法防御（每点代表16.6）
	addSkill("每10秒召唤一名随机4级舰娘，并使其获得20层<振奋>", "援军", "yj", 10)
	addSkill("每7秒弱驱散自身所有负面效果", "塞壬", "sr", 7)

	addSkill("每8秒对当前目标造成[法强*4]的真实伤害，并向附近的敌人弹射4次，每次弹射伤害降低20%", "闪电链", "thunderChain", 8)
	addSkill("<固化>每8秒在当前目标位置上召唤天罚，每秒对该位置上的敌人造成[法强*2]的真实伤害，可叠加、持续到战斗结束为止", "天罚")
	addSkill("<固化>每10秒，提高50%法强<高强度>", "膨胀")

	isHead = true
	giftCha = "cex___al-executer-d"

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="yj":
		yj()
	if id=="sr":
		sr()
	if id=="thunderChain":
		thunderChain()

func yj():
	var cha = summChara(sys.rndListItem(utils.lv4), true)
	cha.addBuff(buffUtil.b_zhenFen.new(20))

func _onBattleStart():
	._onBattleStart()
	addItem(sys.newItem(utils.getRandomItem("MGI")))
	addItem(sys.newItem(utils.getRandomItem("MGI")))
	addItem(sys.newItem(utils.getRandomItem("DEF")))
	skFlag1 = 0
	skFlag2 = 0

func thunderChain():
	var p = 4
	azurHurtChara(aiCha, att.mgiAtk*p, Chara.HurtType.REAL, Chara.AtkType.SKILL, "闪电链")
	yield(reTimer(0.1),"timeout")
	var cha = aiCha.getFirstCha(2, "sortByDistance", false, true)
	if cha == null:return
	p *= 0.8
	azurHurtChara(cha, att.mgiAtk*p, Chara.HurtType.REAL, Chara.AtkType.SKILL, "闪电链")
	for i in range(3):
		yield(reTimer(0.1),"timeout")
		cha = cha.getFirstCha(2, "sortByDistance", false, true)
		if cha == null:return
		p *= 0.8
		azurHurtChara(cha, att.mgiAtk*p, Chara.HurtType.REAL, Chara.AtkType.SKILL, "闪电链")

var skFlag1 = 0
var skFlag2 = 0
var effs = []
var tianFaCells = []
func _upS():
	._upS()
	skFlag1 += 1
	skFlag2 += 1
	if skFlag1 >= 8:
		skFlag1 = 0
		tianFa()
	if skFlag2 >= 10:
		skFlag2 = 0
		pengZhang()
	doTianFa()

func tianFa():
	var eff = createCustEff(aiCha.position, "eff/starDown", 10, true, 1.8, Vector2(0, -20))
	effs.append(eff)
	tianFaCells.append(aiCha.cell)

func doTianFa():
	for i in tianFaCells:
		var cha = matCha(i)
		if cha != null && cha.team != team:
			azurHurtChara(cha, att.mgiAtk*2, Chara.HurtType.REAL, Chara.AtkType.SKILL, "天罚")

func pengZhang():
	addBuff(b_executerd.new())

func _onBattleEnd():
	._onBattleEnd()
	for i in effs:
		if is_instance_valid(i):
			i.queue_free()
	effs.clear()
	tianFaCells.clear()

class b_executerd:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_executerd"	
		att.mgiAtkL = 0.5