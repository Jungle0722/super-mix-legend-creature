extends "../cex___alhide-honoka/cex___alhide-honoka.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」穗香·改"   #角色的名称
	attCoe.mgiAtk += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("周围3格的所有角色每秒获得3层<狂怒><急速><魔力>", "能量同调")

	addSkillTxt("[color=#C0C0C0][现代化改造]-甜蜜陷阱造成的伤害提高200%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
		
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _upS():
	._upS()
	for i in getCellChas(cell, 3, 0):
		i.addBuff(buffUtil.b_kuangNu_r.new(3))
		i.addBuff(buffUtil.b_jiSu_r.new(3))
		i.addBuff(buffUtil.b_moLi.new(3))