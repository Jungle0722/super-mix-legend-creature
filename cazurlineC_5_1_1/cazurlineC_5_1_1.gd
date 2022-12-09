extends "../cazurlineC_5_1/cazurlineC_5_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」最上·花嫁"   #角色的名称
	attCoe.maxHp += 3   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.atk += 2  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("本回合内战斗中复活后，获得10秒<狂化>，并使全体友军获得8层<活力>", "历劫")

	addSkillTxt("[color=#C0C0C0][现代化改造]-每回合第一次转生必定成功(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""

func _onDeath(atkInfo):
	._onDeath(atkInfo)
	addBuff(buffUtil.b_spd.new(20, 10))
	for i in getAllChas(2):
		buffUtil.addHuoLi(i, self, 8)

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")