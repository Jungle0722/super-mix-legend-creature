extends "../cex___als-mikasa/cex___als-mikasa.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」三笠·改"   #角色的名称
	attCoe.atkRan = 3
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("战斗开始时，随机召唤2名具有<亡语>技能的舰娘助战(继承装备)", "对马海之魂")

	addSkillTxt("[color=#C0C0C0][现代化改造]-新生重樱联合、丁字战法对我方重樱舰娘的效果翻倍(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onBattleStart():
	._onBattleStart()
	for i in range(2):
		summChara(sys.rndListItem(utils.deathWordChas), true)