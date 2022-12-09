extends "../cazurlineE_6/cazurlineE_6.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」可畏"   #角色的名称
	attCoe.maxHp += 2
	lv = 3             #等级的设置
	evos = ["cazurlineE_6_1_1"]
	addSkill("我方召唤物阵亡时，随机赋予5名敌人3层<漏水>", "伴随之翼")
	ename = "kewei"
	autoGetSkill()

func _onBattleStart():
	._onBattleStart()
	for i in getAllChas(2):
		if i.chaName.find("瑞鹤") > -1:
			addBuff(buffUtil.b_mgiAtkL.new(30))
			break

func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha) or isDeath or not cha.isSumm:return
	var index = 0
	var chas = getAllChas(1)
	chas.shuffle()
	for i in chas:
		index += 1
		buffUtil.addLouShui(i, self, 3)
		if index >= 5:
			break
