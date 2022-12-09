extends Talent

var buffUtil = globalData.infoDs["g_azurlineBuffs"]
func init():
	name = "连带破坏"
func _connect():
	sys.main.connect("onBattleStart",self,"run5")
	sys.main.connect("onCharaNewChara", self, "onCharaNewChara")

func onCharaNewChara(cha):
	if cha.team == 1:
		cha.addBuff(b_liandaiPH.new())	

func run5():
	for i in sys.main.btChas:
		if i.team == 1:
			i.addBuff(b_liandaiPH.new())

func get_info():
	return "我方角色造成魔法技能伤害时，额外造成[目标血上限20%]的魔法特效伤害，每秒最多触发3次\n[color=#DC143C]此天赋不需要升级，所有MOD通用"

class b_liandaiPH extends Buff:
	var dispel = 2
	var buffName = "连带破坏"
	func _init():
		attInit()
		id = "b_liandaiPH"
	func _connect():
		masCha.connect("onAtkChara",self,"run")
	func run(atkInfo):
		if atkInfo.hurtType == Chara.HurtType.MGI and atkInfo.atkType == Chara.AtkType.SKILL and count < 3:
			count += 1
			atkInfo.atkCha.azurHurtChara(atkInfo.hitCha, min(50000, atkInfo.hitCha.att.maxHp) * 0.2, Chara.HurtType.MGI, Chara.AtkType.EFF, "连带破坏")
	var count = 0
	func _upS():
		count = 0
