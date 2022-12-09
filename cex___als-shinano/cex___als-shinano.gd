extends "../cazurlineE/cazurlineE.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」信浓"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___als-shinano2"]
	addSkill("将初始舰载机替换为性能极强的战斗机：紫电改二", "紫电")
	addSkill("<唯一>预知死生祸福，我方所有角色受到致命伤害时，25%概率将其免疫并获得1层<无敌>，可无限触发判定", "幽蝶之梦")

	autoGetSkill()
	supportSpecEvo = 2
	canCopy = false
	crewEquipName = "「战斗机」紫电改二"
	crewEquip = "cex___plane-ZiDian-2"
	setCamp("重樱")

func _onBattleStart():
	._onBattleStart()
	ydzm()

func ydzm():
	var chas = getAllChas(2)
	for i in chas:
		if not i.hasBuff("b_shinano") && not i.isSumm:
			i.addBuff(b_shinano.new(self))	
	
class b_shinano:
	extends Buff
	var buffName = "幽蝶之梦"
	var dispel = 2
	var utils = globalData.infoDs["g_azurlineUtils"]
	var cha
	func _init(cha = null):
		attInit()
		id = "b_shinano"
		self.cha = cha
	func _connect():
		masCha.connect("onHurt", self, "onHurt")
	func onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 and atkInfo.hurtVal >= masCha.att.hp and masCha.hasBuff("b_wudi") == null and sys.rndPer(25):
			utils.createSkillTextEff("幽蝶之梦", masCha.position)
			masCha.addBuff(utils.buffs.b_wudi.new(1))
			atkInfo.hurtVal = 0