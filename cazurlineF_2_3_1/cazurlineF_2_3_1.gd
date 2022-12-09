extends "../cazurlineF_2_3/cazurlineF_2_3.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「辅助」女灶神·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("友军阵亡会以30%的血量立即复活一次(无法叠加)", "紧急抢修")

	addSkillTxt("[color=#C0C0C0][现代化改造]-紧急抢修触发时，满血复活，且获得3层<活力>(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var p4 = 0.3
func upgrade():
	p4 = 1
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onBattleStart():
	._onBattleStart()
	var chas=getAllChas(2)
	for i in chas:
		if not i.hasBuff("b_jinJiQiangXiu"):
			i.addBuff(b_jinJiQiangXiu.new(p4))

class b_jinJiQiangXiu:
	extends Buff
	var buffUtil = globalData.infoDs["g_azurlineBuffs"]
	var buffName = "紧急抢修"
	var p = 0.3
	var dispel = 2
	func _init(p = 0.3):
		attInit()
		id = "b_jinJiQiangXiu"	
		self.p = p
	func _connect():
		masCha.connect("onDeath",self,"_onDeath")
	func _onDeath(atkInfo):
		if not masCha.isDeath:return
		masCha.isDeath = false
		masCha.plusHp(masCha.att.maxHp * p)
		isDel = true
		buffUtil.addHuoLi(masCha, masCha, 3)
		if masCha.id == "cazurlineE_2_1_1":
			masCha.awakenProcess += 1
			if not masCha.isAwaken and masCha.awakenProcess >= 5:
				masCha.awaken()