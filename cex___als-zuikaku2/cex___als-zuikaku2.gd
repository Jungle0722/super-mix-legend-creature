extends "../cex___als-zuikaku/cex___als-zuikaku.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」瑞鹤·花嫁"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 2
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("赋予所有我方舰载机<亡语>：对当前目标造成[双攻*1]的真实伤害", "最后的精锐")
	addSkillTxt("[color=#C0C0C0][现代化改造]-鹤之奋进持续时间+2秒(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	p3 = 7
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _upS():
	._upS()
	for i in getAllChas(2):
		if i.get("type") == "plane" and i.get("zuikakuFlag") == null:
			i.zuikakuFlag = self 
