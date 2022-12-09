extends "../cex___als-kashino/cex___als-kashino.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「辅助」樫野·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("战斗开始时，周围(九宫格范围)每有1名友军，获得6%减伤(乘算)", "护航")

	addSkillTxt("[color=#C0C0C0][现代化改造]-军备运输收益+60金(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	p3 = 80
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

var bonus = 0

func _onBattleEnd():
	._onBattleEnd()
	bonus = 0

func _onBattleStart():
	._onBattleStart()
	var chas = getAroundChas(cell)
	bonus = 0.06 * chas.size()

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.hurtVal > 0 and bonus > 0:
		atkInfo.hurtVal *= (1-bonus)