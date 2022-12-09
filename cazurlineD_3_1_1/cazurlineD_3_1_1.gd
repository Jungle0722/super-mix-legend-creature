extends "../cazurlineD_3_1/cazurlineD_3_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」君主·誓约"   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 2
	attCoe.def += 2
	attCoe.mgiDef += 2
	addSkill("每{cd}秒将所受的所有伤害的600%施加给当前目标，并清空累计值", "反击之誓约", "fjzsy", 8)

	addSkillTxt("[color=#C0C0C0][现代化改造]-反击之誓约发动后，获得50%减伤，持续3秒(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="fjzsy":
		fjzsy()
var hurtNum1 = 0
func fjzsy():
	if aiCha != null:
		utils.createSkillTextEff("反击之誓约", position)
		azurHurtChara(aiCha, min(aiCha.att.maxHp * 1.6, hurtNum1 * p4), Chara.HurtType.PHY, Chara.AtkType.SKILL, "反击之誓约")
		hurtNum1 = 0
		if upgraded:
			addBuff(buffUtil.b_hurtVal.new(0.5, 3))

func _onBattleStart():
	._onBattleStart()
	hurtNum1 = 0

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if not atkInfo.isMiss && atkInfo.hurtVal > 0:
		hurtNum1 += atkInfo.atkVal

var p4 = 6
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")