extends "../cazurlineE/cazurlineE.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」萨拉托加"   #角色的名称
	attCoe.atk += 1
	evos = ["cazurlineE_2_1","cazurlineE_2_2","cazurlineE_2_3"]
	addSkill("每{cd}秒使用舰炮进行掩护射击，对当前目标造成[法强*3]的伤害，并使其攻击降低30%，持续5秒", "舰炮掩护", "coverShoot", 6)

	lv = 2
	setCamp("白鹰")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="coverShoot":
		coverShoot()

func coverShoot(cha = aiCha):
	if cha == null:
		var skill = getSkill("coverShoot")
		skill.nowTime += 3
		return
	createFlyEff(sprcPos, cha, "sk_feiDang")
	azurHurtChara(cha, att.mgiAtk*3, Chara.HurtType.MGI, Chara.AtkType.SKILL, "舰炮掩护")
	cha.addBuff(buffUtil.b_atkL.new(-3, 5))

