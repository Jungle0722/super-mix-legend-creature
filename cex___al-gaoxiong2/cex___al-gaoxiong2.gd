extends "../cex___al-gaoxiong/cex___al-gaoxiong.gd"
func _info():
	pass
var baseId = ""
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「重巡」高雄·Meta·Lv%d"%level    #角色的名称
	attCoe.maxHp += 3   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 3	 #攻击力（每点代表8.5）
	attCoe.mgiAtk += 3  #魔法攻击（每点代表13.7）
	attCoe.def += 2	#物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkillTxt("[color=#C0C0C0]每次参加战斗即可积累经验，以提升战斗等级，升级可全方位提升实力[/color]")
	addSkillTxt("[color=#C0C0C0][现代化改造]-暴击后获得的圣盾层数+1(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()
		
func awaken(msg = true):
	isAwaken = true
	addSkillTxt("[color=#C0C0C0][心智觉醒]-余烬伤害提高100%")
	p4 = 10
	
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == AtkType.NORMAL && atkInfo.isCri && sys.rndPer(50):
		buffUtil.addShengDun(self, 1)

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	p3 = 2