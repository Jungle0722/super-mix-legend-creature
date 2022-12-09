extends "../azurline_ctrl/Siren.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「塞壬」代行者XIV·Lv%d"%level    #角色的名称
	lv = 3             #等级的设置
	attCoe.atkRan = 4#攻击距离
	attCoe.maxHp = 5#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 4     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 4  #魔法攻击（每点代表13.7）
	attCoe.def = 4     #物理防御（每点代表15）
	attCoe.mgiDef = 4#魔法防御（每点代表16.6）
	atkEff = "atk_gongJian" #攻击时的特效
	evos = ["cex___al-executer-d2"]
	addSkill("每{cd}秒对当前目标造成[法强*3]的真实伤害，并向附近的敌人弹射4次，每次弹射伤害降低20%", "闪电链", "thunderChain", 8)
	addSkill("每{cd}秒在当前目标位置上召唤天罚，每秒对该位置上的敌人造成[法强*1]的真实伤害，可叠加、持续到战斗结束为止", "天罚", "tianFa", 12)
	if id == "cex___al-executer-d":
		addSkillTxt("[color=#C0C0C0]参加18场战斗后，将进化为传奇单位[/color]")
	
func levelUp():
	.levelUp()
	updateAtt()
	
func updateAtt():
	updateTmpAtt("maxHp", 100, false)
	updateTmpAtt("atk", 10, false)
	updateTmpAtt("mgiAtk", 15, false)
	updateTmpAtt("def", 10, false)
	updateTmpAtt("mgiDef", 10, false)
	updateTmpAtt("cd", 0.01, false)
	if level == 20 and gSiren.sirenAwaken:
		call("awaken")
		updateTmpAtt("maxHp", 1500, false)
		updateTmpAtt("atk", 100, false)
		updateTmpAtt("mgiAtk", 150, false)
		updateTmpAtt("def", 100, false)
		updateTmpAtt("mgiDef", 100, false)
		updateTmpAtt("cd", 0.2, false)
	upAtt()

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="thunderChain":
		thunderChain()
	if id == "tianFa":
		tianFa()	

func _onBattleStart():
	._onBattleStart()
	skFlag2 = 0

func thunderChain():
	var p = 3
	var factor = 0.8
	if isAwaken:factor = 1
	azurHurtChara(aiCha, att.mgiAtk*p, Chara.HurtType.REAL, Chara.AtkType.SKILL, "闪电链")
	yield(reTimer(0.1),"timeout")
	var cha = aiCha.getFirstCha(2, "sortByDistance", false, true)
	if cha == null:return
	p *= factor
	azurHurtChara(cha, att.mgiAtk*p, Chara.HurtType.REAL, Chara.AtkType.SKILL, "闪电链")
	for i in range(3):
		yield(reTimer(0.1),"timeout")
		cha = cha.getFirstCha(2, "sortByDistance", false, true)
		if cha == null:return
		p *= factor
		azurHurtChara(cha, att.mgiAtk*p, Chara.HurtType.REAL, Chara.AtkType.SKILL, "闪电链")

var skFlag2 = 0
var effs = []
var tianFaCells = []
func _upS():
	._upS()
	skFlag2 += 1
	if skFlag2 >= 8 and lv == 4:
		skFlag2 = 0
		pengZhang()
	doTianFa()

func tianFa():
	var eff = createCustEff(aiCha.position, "eff/starDown", 10, true, 1.8, Vector2(0, -20))
	effs.append(eff)
	tianFaCells.append(aiCha.cell)
var p2 = 1
func doTianFa():
	for i in tianFaCells:
		var cha = matCha(i)
		if cha != null && cha.team != team:
			azurHurtChara(cha, att.mgiAtk*p2, Chara.HurtType.REAL, Chara.AtkType.SKILL, "天罚")

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
		att.mgiAtkL = 0.3