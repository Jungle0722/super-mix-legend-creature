extends "../cazurlineB_3_2/cazurlineB_3_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」确捷·誓约"   #角色的名称
	attCoe.maxHp += 2
	attCoe.atk += 3
	lv = 4             #等级的设置
	addSkill("闪避时对周围(十字范围)的敌人造成[攻击*(0.25+闪避率)]({damage})的真实伤害", "先进火控")
	addSkillTxt("[color=#C0C0C0][现代化改造]-先进火控伤害系数+0.3(未解锁)")
	addSkillTxt("[color=#C0C0C0]在闪避突破极限后，确捷逐渐有了新的领悟...")
	if upgraded:
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	setGunAndArmor("中型","中型")
	if isAwaken:
		awaken()

var baseId = ""
var p4_2 = 1#先进火控作用范围
func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.isMiss:
		for i in getCellChas(cell, p4_2, 1):
			azurHurtChara(i, att.atk*(p4+att.dod), Chara.HurtType.REAL, Chara.AtkType.SKILL, "先进火控")

var p4 = 0.25
func upgrade():
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	p4 = 0.55

func _onBattleStart():
	._onBattleStart()	
	if att.dod > 1.2 and not isAwaken and team == 1:
		awaken()

func awaken(msg = true):
	chaName = "「轻巡」确捷·觉醒"
	addSkill("先进火控作用范围+1", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "确捷已经获得了心智觉醒！")
	isAwaken = true	
	p4_2 = 2