extends "../cazurlineE_5/cazurlineE_5.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」彼得·施特拉塞"   #角色的名称
	attCoe.maxHp += 2
	lv = 3             #等级的设置
	attCoe.maxHp += 3
	attCoe.def += 3
	attCoe.mgiDef += 2
	attCoe.atkRan = 2
	evos = ["cazurlineE_5_2_1"]

	addSkill("<先手>每{cd}秒起飞一架受自身护甲加成的<舰载机>(←点击可查看说明)", "舰载机", null, null, 0)
	addSkill("<唯一>降低所有敌方单位10%攻速、冷却速度，每秒有10%概率使所有敌人<眩晕>1秒", "侵攻之时")
	autoGetSkill()
	setCamp("铁血")

func _upS():
	._upS()
	if sys.rndPer(10):
		for i in getAllChas(1):
			if i.hasBuff("b_xuanYun") == null:
				i.addBuff(buffUtil.b_xuanYun.new(1))

func _onBattleStart():
	._onBattleStart()
	for i in getAllChas(1):
		if i.hasBuff("b_peter") == null:
			i.addBuff(b_peter.new())

class b_peter:
	extends Buff
	var buffName = "侵攻之时"
	func _init():
		attInit()
		isNegetive = true
		id = "b_peter"
		att.cd = -0.1
		att.spd = -0.1

func castPlane():
	var summ = summPlane()
	if summ != null && not summ.isDeath and team == 1:
		var ap = float(att.def)
		summ.attAdd.maxHp += ap*lv
		summ.plusHp(ap*lv)
		summ.attAdd.def += ap*lv/10.0
		summ.attAdd.mgiDef += ap*lv/10.0
		summ.attAdd.atk += ap*lv/5.0