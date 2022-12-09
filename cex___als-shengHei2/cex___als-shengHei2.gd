extends "../cex___als-shengHei/cex___als-shengHei.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」圣黑之星·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("30%几率格挡来自敌方非塞壬单位的伤害", "圣黑冲击")

	addSkillTxt("[color=#C0C0C0][现代化改造]-格挡成功后赋予目标1层<暴露>(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if sys.rndPer(30):
		atkInfo.hurtVal = 0
		if upgraded:
			buffUtil.addBaoLu(atkInfo.atkCha, 1)