extends "../cazurlineC_3/cazurlineC_3.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」塔林"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 2
	attCoe.mgiDef += 2
	lv = 3             #等级的设置
	evos = ["cazurlineC_3_3_1"]
	addSkill("<先手>每{cd}秒，优先在敌方场内召唤一个完全继承自身装备与随机技能的分身，该分身会立即嘲讽\n				周围3格的敌人并获得2秒<无敌>", "心智分身", "xinZhiFenShen", 10)
	autoGetSkill()
	setCamp("北方联合")

func _onBattleStart():
	._onBattleStart()
	skIndex = 0
	xzfs()

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="xinZhiFenShen":
		xzfs()

var skIndex = 0
# func _upS():
# 	._upS()
# 	skIndex += 1
# 	if skIndex >= 10:
# 		skIndex = 0
# 		xzfs()

func xzfs():
	var cha = summChara("cex___altmp-C331", true, true)
	if cha == null:return
	cha.summoner = self
	cha.addBuff(buffUtil.b_wudi.new(2))
	summedCha.append(cha)
	var r = 3
	if team != 1:r = 1
	if upgraded:cha.enable = true
	for i in getCellChas(cha.cell, r, 1):
		i.addBuff(buffUtil.b_taunt.new(8, cha))
		i.aiCha = cha
	if skillSlot != null:
		cha.enemyGetSkill(skillSlot)