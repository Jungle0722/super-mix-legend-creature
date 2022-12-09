extends "../cazurlineB_1_2/cazurlineB_1_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」贝法·幼"   #角色的名称
	attCoe.maxHp += 4   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 2
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("<唯一>战斗开始时，并附加4秒<眩晕>", "战术解放·贝法")
	addSkillTxt("[color=#C0C0C0][现代化改造]-战术解放持续时间+1(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")


var baseId = ""

func _onBattleStart():
	._onBattleStart()
	yield(reTimer(1),"timeout")
	var chas = getAllChas(1)
	for i in chas:
		if i.hasBuff("b_xuanYun") == null:
			i.addBuff(buffUtil.b_xuanYun.new(p4))

var p4 = 4
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	p4 = 5
	

