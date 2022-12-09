extends "../cazurlineE/cazurlineE.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」加贺"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 1     #攻击力（每点代表8.5）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___als-kaga2"]
	canCopy = false
	addSkill("战斗开始时，分别对物攻、魔攻最高的敌人造成[法强*10]({damage})的真实伤害，并附带10秒<虚弱>", "先手必胜")
	addSkill("每{cd}秒赋予全体敌人4层<漏水>", "战无不胜", "invincible", 12)

	addSkillTxt("[color=#C0C0C0][羁绊·一航战]-我方场上存在赤城时，先手必胜额外分别对两名敌人生效[/color]")

	setGunAndArmor("小型","中型")
	autoGetSkill()
	type = "cv"
	supportSpecEvo = 2
	setCamp("重樱")
var jbFlag = 1
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="invincible":
		invincible()

func _onBattleStart():
	._onBattleStart()
	firstMover()
	jbFlag = 1
	for i in getAllChas(2):
		if i.chaName.find("赤城") > -1:
			jbFlag = 3
			break

func invincible():
	utils.createSkillTextEff("战无不胜", position)
	var chas = getAllChas(1)
	for i in chas:
		buffUtil.addLouShui(i, self, 4)

func firstMover():
	var p1 = 5
	var p2 = 10
	var enemy = getAllChas(1)
	enemy.sort_custom(self,"sortByAtkDesc")
	
	for i in range(jbFlag):
		if i >= enemy.size():break
		createCustEff(enemy[i].position, "eff/thunder", 15, false, 1.3, Vector2(0, -20))
		azurHurtChara(enemy[i], att.mgiAtk*p1, Chara.HurtType.REAL, Chara.AtkType.SKILL, "先手必胜")
		enemy[i].addBuff(utils.buffs.b_weak.new(p2))
	
	enemy = getAllChas(1)
	enemy.sort_custom(self,"sortByMgiAtkDesc")
	for i in range(jbFlag):
		createCustEff(enemy[i].position, "eff/thunder", 15, false, 1.3, Vector2(0, -20))
		azurHurtChara(enemy[i], att.mgiAtk*p1, Chara.HurtType.REAL, Chara.AtkType.SKILL, "先手必胜")
		enemy[i].addBuff(utils.buffs.b_weak.new(p2))