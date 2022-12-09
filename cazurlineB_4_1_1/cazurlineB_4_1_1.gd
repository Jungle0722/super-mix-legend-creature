extends "../cazurlineB_4_1/cazurlineB_4_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」黛朵·誓约"   #角色的名称
	attCoe.atk += 3     #攻击力（每点代表8.5）
	attCoe.maxHp += 3
	lv = 4             #等级的设置
	addSkill("战斗开始时，使我方法强及攻击最低的角色与敌方法强及攻击最高的角色进行中和<中强度>\n		中和后双方法强/物攻均相等", "制衡")

	setGunAndArmor("中型","中型")
	addSkillTxt("[color=#C0C0C0][现代化改造]-皇家女仆提高的层数+2(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""

func _onBattleStart():
	._onBattleStart()
	yield(reTimer(0.5),"timeout")
	var enemy = getAllChas(1)
	var ally = getAllChas(2)
	#==========================攻击======================
	enemy.sort_custom(self,"sortByAtkDesc")
	ally.sort_custom(self,"sortByAtk")

	#我方
	var c1 = utils.getFirstFromChas(ally)
	#敌方
	var c2 = utils.getFirstFromChas(enemy)

	var b1 = c1.hasBuff("b_balance")
	var b2 = c2.hasBuff("b_balance")
	var atk = min(3000, (c1.att.atk+c2.att.atk)*0.5-c1.att.atk)
	if b1 == null:
		c1.addBuff(b_balance.new(atk, 0))
	else:
		b1.att.atk += atk
		
	if b2 == null:
		c2.addBuff(b_balance.new((c1.att.atk+c2.att.atk)*0.5-c2.att.atk, 0))
	else:
		b2.att.atk += (c1.att.atk+c2.att.atk)*0.5-c2.att.atk

	#==========================法强======================
	enemy.sort_custom(self,"sortByMgiAtkDesc")
	ally.sort_custom(self,"sortByMgiAtk")

	#我方
	c1 = utils.getFirstFromChas(ally)
	#敌方
	c2 = utils.getFirstFromChas(enemy)

	b1 = c1.hasBuff("b_balance")
	b2 = c2.hasBuff("b_balance")
	var mgiAtk = min(3000, (c1.att.mgiAtk+c2.att.mgiAtk)*0.5-c1.att.mgiAtk)
	if b1 == null:
		c1.addBuff(b_balance.new(0, mgiAtk))
	else:
		b1.att.mgiAtk += mgiAtk

	if b2 == null:
		c2.addBuff(b_balance.new(0, (c1.att.mgiAtk+c2.att.mgiAtk)*0.5-c2.att.mgiAtk))
	else:
		b2.att.mgiAtk += (c1.att.mgiAtk+c2.att.mgiAtk)*0.5-c2.att.mgiAtk


class b_balance:
	extends Buff
	var buffName = "制衡"
	var dispel = 2
	func _init(atk, mgiAtk):
		attInit()
		id = "b_balance"
		if atk + mgiAtk < 0:
			isNegetive = true
		if atk > 0:
			att.atk = atk
		if mgiAtk > 0:
			att.mgiAtk = mgiAtk
	func _upS():
		if att.atk + att.mgiAtk < 0:
			isNegetive = true
		else:
			isNegetive = false

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	p3 = 7