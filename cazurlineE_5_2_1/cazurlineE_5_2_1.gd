extends "../cazurlineE_5_2/cazurlineE_5_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」彼得·施特拉塞·改"   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	addSkill("每{cd}秒指挥自己召唤的所有舰载机对当前目标发起总攻，造成[自身护甲*5]({damage})的物理伤害，附带2层<流血>", "迅击铁翼", "sk_xjty", 6)

	addSkillTxt("[color=#C0C0C0][现代化改造]-迅击铁翼伤害系数+5(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var p4 = 5
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="sk_xjty" and aiCha != null:
		sk_xjty()

func sk_xjty():
	for i in summedCha:
		azurHurtChara(aiCha, att.def * p4, Chara.HurtType.PHY, Chara.AtkType.SKILL, "迅击铁翼")
		

var baseId = ""

func upgrade():
	p4 = 10
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")