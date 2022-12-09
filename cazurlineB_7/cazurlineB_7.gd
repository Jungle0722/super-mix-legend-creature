extends "../cazurlineB/cazurlineB.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」摩尔曼斯克"   #角色的名称
	attCoe.atkRan = 4  #攻击距离
	attCoe.atk += 1
	attCoe.maxHp += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 2             #等级的设置
	atkEff = "atk_gongJian" #攻击时的特效
	evos = ["cazurlineB_7_1"]
	addSkill("每{cd}秒赋予随机4名敌人4层<霜冻>，并造成[攻击*2]({damage})的技能伤害", "重击冰魄", "zhongjiBP", 8)
	setGunAndArmor("小型","中型")
	setCamp("北方联合")
	ename = "moermansike"

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="zhongjiBP":
		zhongjiBP()

func zhongjiBP():
	var dmg = getSkillEffect("重击冰魄")
	if upgraded:dmg *= 1.5
	for i in utils.getRndEnemys(self, 4):
		i.addBuff(buffUtil.b_freeze.new(4))
		azurHurtChara(i, dmg, Chara.HurtType.PHY, Chara.AtkType.SKILL, "重击冰魄")
	