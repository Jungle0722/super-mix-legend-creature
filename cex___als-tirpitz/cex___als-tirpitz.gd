extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」提尔比茨"   #角色的名称
	attCoe.atkRan = 4
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___als-tirpitz2"]
	canCopy = false
	addSkill("当我方场上存在俾斯麦时，提高50%暴击爆伤攻速，并对任何冒犯俾斯麦的敌人发起普攻", "姐妹同心")
	addSkill("每次普攻损失[血上限*5%]({damage})的血量，并对目标额外造成[损失量*10]的可暴击物理伤害", "战略威慑")

	autoGetSkill()
	supportSpecEvo = 2
	setCamp("铁血")
var p3 = 10
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL and aiCha != null and att.hp/att.maxHp > 0.15:
		var num = att.maxHp*0.05
		forceHurtSelf(num)
		if num < 0:num *= -1
		azurHurtChara(aiCha, num * p3, Chara.HurtType.PHY, Chara.AtkType.SKILL, "战略威慑", true)

func _onBattleStart():
	._onBattleStart()
	for i in getAllChas(2):
		if i.chaName.find("俾斯麦") > -1:
			addBuff(b_tirpitz2.new())
			i.addBuff(b_tirpitz1.new(self))
			break

class b_tirpitz1:
	extends Buff
	var buffName = "姐妹同心"
	var cha
	var dispel = 2
	var utils = globalData.infoDs["g_azurlineUtils"]
	func _init(cha = null):
		id = "b_tirpitz1"
		self.cha = cha
	func _connect():
		masCha.connect("onHurt",self,"onHurt")
	func onHurt(atkInfo):
		cha.normalAtkChara(atkInfo.atkCha)

class b_tirpitz2:
	extends Buff
	var buffName = "姐妹同心"
	func _init():
		attInit()
		id = "b_tirpitz2"
		att.cri = 0.5
		att.criR = 0.5
		att.spd = 0.5
