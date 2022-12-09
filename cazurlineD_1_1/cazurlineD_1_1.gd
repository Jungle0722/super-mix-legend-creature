extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「战列」俾斯麦"   #角色的名称
	attCoe.atkRan = 3  #攻击距离
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___azurlineD"]
	addSkill("<唯一>装备Z旗时，使我方舰娘获得的Z旗反伤效果系数每秒提高3%", "铁血宰相")
	addSkill("<限定><唯一>装备Z旗时，我方铁血阵营角色受到致命伤害时获得3秒<无敌>并恢复50%血量", "帝国旗舰")

	autoGetSkill()
	setCamp("铁血")

var chasDic = {}
func _onBattleStart():
	._onBattleStart()
	yield(reTimer(0.5),"timeout")
	for i in items:
		if i.id == "i_Hide_al_flagz":
			for j in getAllChas(2):
				var bf = j.hasBuff("b_flag_z")
				if j.hasBuff("b_flag_z") != null:
					chasDic[j.rndId] = bf
					j.addBuff(b_bismark.new())
		return

func _onBattleEnd():
	._onBattleEnd()
	chasDic = {}

func _upS():
	._upS()
	if chasDic.empty():return
	for i in chasDic.values():
		if i == null:continue
		i.plusReflect(0.03)

class b_bismark:
	extends Buff
	var buffName = "帝国旗舰"
	var dispel = 2
	var utils = globalData.infoDs["g_azurlineUtils"]
	func _init():
		attInit()
		id = "b_bismark"
	func _connect():
		masCha.connect("onHurt", self, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 and atkInfo.hurtVal*1.2 >= masCha.att.hp and masCha.hasBuff("b_wudi") == null:
			masCha.addBuff(utils.buffs.b_wudi.new(3))
			masCha.healCha(masCha, masCha.att.maxHp*0.5)
			atkInfo.hurtVal = 0
			self.isDel = true