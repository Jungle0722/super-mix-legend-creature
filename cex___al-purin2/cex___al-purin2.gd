extends "../cex___al-purin/cex___al-purin.gd"
func _info():
	pass
func _connect():
	._connect()
var baseId = ""
func _extInit():
	._extInit()
	chaName = "「辅助」彩布里·Lv4"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 1     #攻击力（每点代表8.5）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4            #等级的设置
	addSkill("回合开始时，15%概率为战场上一名随机友军角色进行现代化改造", "小扳手")
	
	addSkillTxt("[color=#C0C0C0][现代化改造]-Purin触发概率+10%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func upgrade():
	p3 = 30
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func _onBattleStart():
	._onBattleStart()
	if sys.rndPer(15):
		xbs()

func xbs():
	for i in getAllChas(2):
		if not i.has_method("upgrade") or i.get("upgraded") == true:continue
		i.upgrade()
		i.upgraded = true
		print("彩布里触发现代化改造成功：%s"%i.chaName)
		break

