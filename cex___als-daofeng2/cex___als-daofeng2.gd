extends "../cex___als-daofeng/cex___als-daofeng.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」岛风·改"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1
	attCoe.mgiAtk += 1
	lv = 4             #等级的设置
	addSkill("每次瞬移后对当前目标造成[法强*12]({damage})的技能伤害", "迅光雷袭")
	addSkillTxt("[color=#C0C0C0][现代化改造]-每次瞬移后获得2层<圣盾><模糊>(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

