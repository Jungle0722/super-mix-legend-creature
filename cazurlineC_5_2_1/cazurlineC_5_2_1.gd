extends "../cazurlineC_5_2/cazurlineC_5_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」伊吹·花嫁"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.atk += 3  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("<固化>每8秒触发我方所有单位的亡语效果", "回响")
	addSkillTxt("[color=#C0C0C0][现代化改造]-死亡后立即触发一次回响(未解锁)")
	addSkillTxt("[color=#C0C0C0]不断地回响，伊吹逐渐有了新的领悟...")
	if upgraded:
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()

func awaken(msg = true):
	chaName = "「重巡」伊吹·觉醒"
	addSkill("心神合一触发概率100%，本回合内回响每次触发亡语效果时，提高10%普攻伤害(上限300%)", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "伊吹已经获得了心智觉醒！")
	isAwaken = true	
		
var baseId = ""

var upsIndex = 0
func _upS():
	._upS()
	upsIndex += 1
	if upsIndex >= 10:
		upsIndex = 0
		yc_hx()
		awakenProcess += 1
		if awakenProcess >= 30 and not isAwaken:
			awaken()

func _onBattleEnd():
	._onBattleEnd()
	upsIndex = 0
	p3 = 1

func upgrade():
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")