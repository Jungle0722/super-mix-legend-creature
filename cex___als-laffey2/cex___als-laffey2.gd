extends "../cex___als-laffey/cex___als-laffey.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」拉菲·改"   #角色的名称
	attCoe.maxHp += 3   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 3
	lv = 4             #等级的设置
	addSkill("歼灭模式启动后，获得10层<圣盾><模糊>，冲向血上限最低的敌人并将其秒杀", "所罗门战神")

	addSkillTxt("[color=#C0C0C0][现代化改造]-磁性鱼雷杀伤范围+1(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	warGod = true
func upgrade():
	p3 = 2
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

