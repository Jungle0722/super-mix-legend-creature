extends "../cazurlineB/cazurlineB.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」圣地亚哥"   #角色的名称
	attCoe.atkRan = 3
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___alcamp-sandiego2"]
	canCopy = false
	ename = "shengdiyage"

	addSkill("本回合内，每次普攻提高自身10%攻速(上限500%)", "沙场老兵")
	addSkill("造成普攻或技能伤害时额外附加[对该单位已造成伤害总量]的物理特效伤害(上限攻击*40)", "战斗回放")

	autoGetSkill()
	supportSpecEvo = 2
	setCamp("白鹰")
var dmgMap = {}
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType != Chara.AtkType.EFF:
		azurHurtChara(atkInfo.hitCha, min(att.atk*40, utils.dicGet(dmgMap, atkInfo.hitCha, 0)), Chara.HurtType.PHY, Chara.AtkType.EFF, "战斗回放")
	utils.dicPlus(dmgMap, atkInfo.hitCha, atkInfo.hurtVal)

func _onBattleEnd():
	._onBattleEnd()
	dmgMap.clear()

func _onBattleStart():
	._onBattleStart()
	addBuff(b_sandiego.new())

class b_sandiego:
	extends Buff
	var buffName = "沙场老兵"
	var dispel = 2
	func _init():
		attInit()
		id = "b_sandiego"
	func _connect():
		masCha.connect("onAtkChara",self,"run")
	func run(atkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL and att.spd < 5:
			att.spd += 0.1