extends "../azurline_ctrl/TBF.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「鱼雷机」飞龙"   #角色的名称
	attCoe.mgiAtk += 2
	attAdd.mgiPen += 150
	lv = 4             #等级的设置
	addSkillTxt("每6秒获得8层<魔力>，并使自身所有技能的冷却时间降低0.5秒")
	addSkillTxt("每5秒，向随机3名敌人发射航空鱼雷，分别对直线上的敌人造成[双攻*0.1]的真实伤害，并附带5层漏水")
	addSkillTxt("任意友军单位死亡，均会提高20点法强及2%冷却速度")
	addCdSkill("flyDragon", 5)
	addCdSkill("flyDragon00", 6)
	
var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "flyDragon00":
		addBuff(buffUtil.b_moLi.new(8))
		for i in skills:
			if i.cd/(1+att.cd) - i.nowTime > 0.6:
				i.nowTime += 0.5
	if id == "flyDragon":
		flyDragon()

func flyDragon():
	for i in range(3):
		var cha = utils.getRndEnemy(self)
		if cha == null:break
		var eff2:Eff = sys.newEff("animEff", position)
		eff2.setImgs(direc + "eff/thunderFly", 9, true)
		eff2._initFlyPos(position + (cha.position - position).normalized() * 1000, 350)
		eff2.normalSpr.position = Vector2(0, -30)
		eff2.connect("onInCell",self,"effInCell")
		yield(reTimer(0.2),"timeout")

func effInCell(cell):
	var cha = matCha(cell)
	if cha == null:
		cha = matCha(cell + Vector2(0, 1))
	if cha != null && cha.team != team:
		azurHurtChara(cha, (att.atk+att.mgiAtk)*0.1, Chara.HurtType.REAL, Chara.AtkType.SKILL, "飞龙", true)
		buffUtil.addLouShui(cha, self, 5)

func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha):return
	if cha.team == team:
		updateTmpAtt("mgiAtk", 20)
		updateTmpAtt("cd", 0.02)