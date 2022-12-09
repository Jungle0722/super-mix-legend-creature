extends "../cazurlineD_3/cazurlineD_3.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「战列」南达科他"   #角色的名称
	lv = 3             #等级的设置
	evos = ["cazurlineD_3_2_1"]
	addSkill("替全队承受40%的非特效伤害，每{cd}秒恢复承受伤害40%的生命值", "最强之盾", "zqzd", 10)

	xfSkillFlag = false
	autoGetSkill()
	setCamp("白鹰")
var p3 = 0.4
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="zqzd":
		zqzd()

func zqzd():
	if num > 0:
		healCha(self, num)
		num = 0

var num = 0
func _upS():
	._upS()
	if storage > 0:
		if aiCha != null and aiCha.get("tag") == "azurline":
			azurHurtChara(self, storage, Chara.HurtType.PHY, Chara.AtkType.EFF, "最强之盾-伤害结算")
		else:
			azurHurtChara(self, storage, Chara.HurtType.PHY, Chara.AtkType.EFF, "最强之盾-吸收伤害")
		storage = 0

func _onBattleStart():
	._onBattleStart()
	num = 0
	storage = 0
	var chas = getAllChas(2)
	for i in chas:
		if not i.hasBuff("b_NP_zqzd"):
			i.addBuff(utils.buffs.b_NP_zqzd.new(self))
	
func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.hurtVal > 0 && not atkInfo.isMiss:
		num += atkInfo.hurtVal * p3


