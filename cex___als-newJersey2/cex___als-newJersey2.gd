extends "../cex___als-newJersey/cex___als-newJersey.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」新泽西·改"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 3
	attCoe.def += 2
	attCoe.mgiDef += 2
	lv = 4             #等级的设置
	addSkill("击杀塞壬时，永久提高25攻击，并获得25金币(猎杀高级塞壬翻倍)", "猎杀巨兽")

	addSkillTxt("[color=#C0C0C0][现代化改造]-对塞壬造成伤害时，若目标血量低于15%，则将其斩杀(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""
func _onKillChara(atkInfo):
	._onKillChara(atkInfo)	
	if atkInfo.hitCha.get("type") == "BOSS":
		updateTmpAtt("atk", 25)
		sys.main.player.plusGold(25)
		if atkInfo.hitCha.get("isHead") == true:
			updateTmpAtt("atk", 25)
			sys.main.player.plusGold(25)

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if upgraded and atkInfo.atkType != Chara.AtkType.EFF && atkInfo.hitCha.att.hp/atkInfo.hitCha.att.maxHp <= 0.15 and atkInfo.hitCha.get("type") == "BOSS":
		atkInfo.hurtVal = 0
		utils.createSkillTextEff("斩杀", position)
		atkInfo.hitCha.forceHurtSelf(atkInfo.hitCha.att.maxHp)
		increDmgNum(atkInfo.hitCha.att.hp, "斩杀", atkInfo.hitCha)
		