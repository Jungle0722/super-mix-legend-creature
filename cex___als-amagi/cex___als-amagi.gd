extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」天城"   #角色的名称
	attCoe.atkRan = 3
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 3     #攻击力（每点代表8.5）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___als-amagi2"]
	canCopy = false
	ename = "tiancheng"

	addSkill("每击杀一名非召唤单位，积攒一点[魂]，上限20魂，每点魂提升30点攻击及3%攻速，魂在回合结束\n时不会消失", "灵魂收集")
	addSkill("<亡语>死亡时，对当前目标周围2格的敌人造成[魂数*攻击]的真实伤害，并损失一半的魂\n					(触发亡语不损失魂)", "灵魂逸散")
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("重樱")

func _onKillChara(atkInfo):
	._onKillChara(atkInfo)	
	if not atkInfo.hitCha.isSumm:
		soul += 1
		soul = min(20, soul)

func deathWord():
	.deathWord()
	for i in getCellChas(aiCha.cell, 2, 1):
		azurHurtChara(i, att.atk*soul, Chara.HurtType.REAL, Chara.AtkType.SKILL, "灵魂逸散")
	if isDeath:soul *= 0.5
		
func _onBattleStart():
	._onBattleStart()
	addBuff(b_amagi.new())
var soul:int = 0
class b_amagi:
	extends Buff
	var buffName = "灵魂收集"
	var dispel = 2
	func _init():
		attInit()
		id = "b_amagi"
	func _upS():
		att.atk = masCha.soul * 30
		att.spd = masCha.soul * 0.03