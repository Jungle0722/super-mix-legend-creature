extends "../cazurlineE_2_2/cazurlineE_2_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」埃塞克斯"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 3     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 3
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	summLimit = 999
	addSkill("机库没有容量限制，场上任何非召唤单位死亡时，有20%概率起飞一架舰载机", "善战之舰")

	addSkillTxt("[color=#C0C0C0][现代化改造]-善战之舰触发概率+20%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setCamp("白鹰")

var baseId = ""
	
func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha):return
	if not cha.isSumm && sys.rndPer(p4):
		castPlane()

var p4 = 20
func upgrade():
	p4 = 40
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")