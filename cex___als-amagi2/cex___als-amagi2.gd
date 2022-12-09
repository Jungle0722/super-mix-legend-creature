extends "../cex___als-amagi/cex___als-amagi.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」天城·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("魂满后会开始吟唱大招，吟唱时间3秒，期间无法普攻，每受到一次攻击，吟唱时间增加0.5秒，\n				吟唱成功后，释放一半的魂，对当前目标周围4格的敌人造成[攻击*12]的真实伤害", "魂之挽歌")

	addSkillTxt("[color=#C0C0C0][现代化改造]-队友击杀的敌人使自己获得1点魂(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""
var skIndex = 0
var sing = false
func _upS():
	._upS()
	if soul == 20:
		sing = true
	if sing:
		skIndex += 1
		if skIndex >= 3:
			soulSing()

func soulSing():
	utils.createSkillTextEff("灵魂吟唱", position)
	sing = false
	skIndex = 0
	for i in getCellChas(aiCha.cell, 4, 1):
		azurHurtChara(i, att.atk*8, Chara.HurtType.REAL, Chara.AtkType.SKILL, "灵魂逸散")
	soul *= 0.5

func normalAtkChara(cha):
	if not sing:
		.normalAtkChara(cha)

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.hurtVal > 0 and sing:
		skIndex -= 0.5

func _onBattleEnd():
	._onBattleEnd()
	sing = false
	skIndex = 0

func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha):return
	if not cha.isSumm and cha.team != team:
		soul += 1