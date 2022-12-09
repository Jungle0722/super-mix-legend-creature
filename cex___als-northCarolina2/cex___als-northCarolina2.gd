extends "../cex___als-northCarolina/cex___als-northCarolina.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」北卡罗来纳·改"   #角色的名称
	attCoe.atkRan = 3
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("受到普攻伤害时，30%概率使攻击者<眩晕>2秒", "自由之光")

	addSkillTxt("[color=#C0C0C0][现代化改造]-剥被帽装甲回血系数+20%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	p3 = 0.5
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL and sys.rndPer(30):
		atkInfo.atkCha.addBuff(buffUtil.b_xuanYun.new(2))