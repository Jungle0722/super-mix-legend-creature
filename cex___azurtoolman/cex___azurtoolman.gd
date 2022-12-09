extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
var flag2 = true
func _extInit():
	._extInit()
	chaName = "工具人"   #角色的名称
	attCoe.atkRan = 20  #攻击距离
	attCoe.maxHp = 4000   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 0     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 10  #魔法攻击（每点代表13.7）
	attCoe.def = 30     #物理防御（每点代表15）
	attCoe.mgiDef = 30 #魔法防御（每点代表16.6）
	attAdd.spd = 1
	attAdd.suck = 2
	attAdd.cri = 1
	attAdd.defR = 0.8
	attAdd.penL = 1
	lv = 4            #等级的设置
	atkEff = "atk_dang" #攻击时的特效
	type = "siren"
	# addSkillText("当场上只剩下自己时，每秒对所有敌人造成其血上限1000%的真实伤害")
	addSkill("每{cd}秒使所有敌人时间暂停，持续3秒", "时停结界", "test", 5)

var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="test":
		test()

func test():
	pass
	# for i in getAllChas(1):
	# 	i.pause(3)
		# i.timer.paused = true
		# i.get_node("spr").pause_mode = Node.PAUSE_MODE_PROCESS
		# i.timer.pause_mode = Node.PAUSE_MODE_PROCESS
		# i.print_tree_pretty()
		# break
	
var index = 0
func _upS():
	._upS()
	for i in getAllChas(1):
		azurHurtChara(i, i.att.maxHp*10, Chara.HurtType.REAL, Chara.AtkType.EFF, "sk")
	for i in getAllChas(1):
		azurHurtChara(i, i.att.maxHp*10, Chara.HurtType.REAL, Chara.AtkType.EFF, "sk")
	for i in buffs:
		if i.isNegetive:
			i.isDel = true
	index += 1


func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if team == 1:
		atkInfo.hurtVal = 0

# func _onBattleStart():
# 	._onBattleStart()
# 	print(get_node("ui/items/g"))

# func _input(event):
# 	if sys.main.isAiStart:return
# 	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
# 		var cha = sys.main.selCha
# 		if cha != null:
# 			var name = cha.chaName
# 			yield(reTimer(0.2),"timeout")
# 			if cha == null or cha.get_parent() == null:
# 				print("检测到角色%s被售卖"%name)
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	atkInfo.factor += index

# func _onBattleStart2():
# 	#乒乓球
# 	# var fromCha = self
# 	# for i in range(10):
# 	# 	var toCha = utils.getRndEnemy(fromCha)
# 	# 	createJiGuang(fromCha.global_position, toCha.global_position, fromCha)
# 	# 	fromCha = toCha
# 	# 	yield(reTimer(0.3),"timeout")
# 	for i in range(30):
# 		createJiGuang(global_position, aiCha.global_position, self)
# 		yield(reTimer(0.15),"timeout")	
# 		for cha in utils.lineChas(cell, aiCha.cell, 10):
# 			if cha.team != team:
# 				azurHurtChara(cha, 100000, Chara.HurtType.MGI, Chara.AtkType.SKILL, "光能主炮", true)

# func createJiGuang(srcPos, toPos, cha):
# 	var eff:Eff = cha.newEff("sk_jiGuan", srcPos)
# 	eff.sprLookAt(toPos)
# 	eff.scale *= 2
# 	eff.normalSpr.position = Vector2(0, -25)
# 	eff.spr.scale.x = 1.5