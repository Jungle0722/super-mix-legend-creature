extends "../cex___alhide-nagisa/cex___alhide-nagisa.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」凪咲·改"   #角色的名称
	attCoe.mgiAtk += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("战斗开始时分别赋予血上限最高与最低的1名友军<无光之盾>", "无光之盾")

	addSkillTxt("[color=#C0C0C0][现代化改造]-链式反应最后一次弹射将造成[目标血上限100%]的真实伤害(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
		
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

class b_nagisa:
	extends Buff
	var buffName = "无光之盾"
	var dispel = 2
	var num = 0
	var start = false
	var index = 0
	var buffUtil = globalData.infoDs["g_azurlineBuffs"]
	func _init():
		attInit()
		id = "b_nagisa"
	func _connect():
		masCha.connect("onHurt", self, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 and start:
			num += atkInfo.hurtVal
			atkInfo.hurtVal = 0
	func _del():
		._del() 
		masCha.addBuff(buffUtil.b_nagisa2.new(num))
	func _upS():	
		if index >= 10:
			isDel = true
		if not start and masCha.att.hp/masCha.att.maxHp <= 0.5:
			start = true
		if start:
			index += 1
