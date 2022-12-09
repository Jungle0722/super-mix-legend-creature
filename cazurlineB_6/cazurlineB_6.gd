extends "../cazurlineB/cazurlineB.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」欧若拉"   #角色的名称
	attCoe.atkRan = 5  #攻击距离
	attCoe.atk += 4
	attCoe.maxHp += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 2             #等级的设置
	atkEff = "atk_gongJian" #攻击时的特效
	evos = ["cazurlineB_6_1", "cazurlineB_6_2", "cazurlineB_6_3"]
	addSkill("普攻锁定血量最低的队友，不再造成伤害，而是为其恢复等额的血量", "战斗辅助")
	type2 = "doctor"
	setGunAndArmor("小型","中型")
	setCamp("皇家")

#友军目标数
var p2 = 1
#敌军目标数
var p4 = 0
#敌人伤害系数
var p4_1 = 0.3

func setAiCha(cha):
	aiCha = getFirstCha(1, "sortByDistance")
	$ui / Label.text = "%s|%s" % [name, aiCha.name]
	
func normalAtkChara(cha):
	if not is_instance_valid(cha):return
	var chas = getAllChas(2)
	chas.sort_custom(self, "sortByHp")

	for i in range(p2):
		if i >= chas.size():break
		.normalAtkChara(chas[i])

	if p4 > 0:
		var enemy = utils.getRndEnemy(self)
		.normalAtkChara(enemy)

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.hitCha.team == team:
		atkInfo.hurtVal = 0

	if atkInfo.atkType == Chara.AtkType.MISS || atkInfo.isMiss:
		atkInfo.isMiss = false
		atkInfo.atkType = Chara.AtkType.NORMAL

	if atkInfo.atkType == Chara.AtkType.NORMAL:
		if atkInfo.hitCha.team == team:
			if team == 1:
				healCha(atkInfo.hitCha, atkInfo.atkVal)
			else:
				healCha(atkInfo.hitCha, atkInfo.atkVal * 0.5)
			if ename == "laibixi":
				buffUtil.addHuoLi(atkInfo.hitCha, self, 3)
		elif p4 > 0:
			if team == 1:
				atkInfo.atkType = Chara.AtkType.SKILL
				atkInfo.hurtType = Chara.HurtType.REAL
				atkInfo.hurtVal = atkInfo.atkVal
				atkInfo.hurtVal *= p4_1
			else:
				atkInfo.hurtVal = min(atkInfo.hitCha.att.maxHp*1.2, atkInfo.hurtVal*2)

	
		
	