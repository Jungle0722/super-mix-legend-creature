extends "../cex___als-veneto/cex___als-veneto.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」维托里奥·维内托·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("暴击后额外附带[四维*2]({damage})的物理普攻伤害", "永夜晨光")

	addSkillTxt("[color=#C0C0C0][现代化改造]-帝国雄心也能对重樱舰娘生效(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.isCri:
		azurHurtChara(atkInfo.hitCha, getSkillEffect("永夜晨光"), Chara.HurtType.PHY, Chara.AtkType.NORMAL, "永夜晨光")