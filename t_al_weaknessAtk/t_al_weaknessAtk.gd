extends Talent

var buffUtil = globalData.infoDs["g_azurlineBuffs"]
func init():
	name = "弱点攻击"
func _connect():
	sys.main.connect("onBattleStart",self,"run5")
	sys.main.connect("onCharaNewChara", self, "onCharaNewChara")

func onCharaNewChara(cha):
	if cha.team == 1:
		cha.addBuff(b_weaknessAtk.new())	

func run5():
	for i in sys.main.btChas:
		if i.team == 1:
			i.addBuff(b_weaknessAtk.new())

func get_info():
	return "我方角色(含召唤物)造成普攻伤害暴击时，额外造成[目标血上限20%]的物理伤害\n[color=#DC143C]此天赋不需要升级，所有MOD通用"

class b_weaknessAtk extends Buff:
	var dispel = 2
	var buffName = "弱点攻击"
	func _init():
		attInit()
		id = "b_weaknessAtk"
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL and atkInfo.isCri:
			if atkInfo.atkCha.get("tag") == "azurline":
				atkInfo.atkCha.azurHurtChara(atkInfo.hitCha, min(40000, atkInfo.hitCha.att.maxHp) * 0.2, Chara.HurtType.PHY, Chara.AtkType.EFF, "弱点攻击")
			else:
				atkInfo.atkCha.hurtChara(atkInfo.hitCha, min(40000, atkInfo.hitCha.att.maxHp) * 0.2, Chara.HurtType.PHY, Chara.AtkType.EFF)
