extends "../cazurlineC_3/cazurlineC_3.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」印第安纳波利斯·觉醒"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1
	lv = 3             #等级的设置
	evos = ["cex___al-indianapolis2"]
	supportSpecEvo = 2
	canCopy = false
	prefer = "t"
	ename = "bolisi"

	addSkill("<亡语>死亡时，对所有敌人造成[目标血上限30%]的真实特效伤害", "玉石俱焚")
	isAwaken = true
	autoGetSkill()
	prefer = "t"

func deathWord():
	.deathWord()
	var p = 0.1
	if isDeath:p = 0.3
	for i in getAllChas(1):
		azurHurtChara(i, maxHp(i)*p, Chara.HurtType.REAL, Chara.AtkType.EFF, "玉石俱焚")