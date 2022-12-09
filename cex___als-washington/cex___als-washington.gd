extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」华盛顿"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2
	attCoe.def += 2
	attCoe.mgiDef += 2
	attCoe.atkRan = 4
	lv = 3             #等级的设置
	evos = ["cex___als-washington2"]
	addSkill("<唯一>我方舰娘获得25%物理/法术吸血，白鹰舰娘额外获得15%伤害减免", "天佑白鹰")
	addSkill("每{cd}秒对所有敌方重樱/塞壬阵营舰娘造成[我方白鹰舰娘数*自身双攻*0.5]的物理技能伤害", "落樱神斧", "luoYingShenfu", 8)

	autoGetSkill()
	supportSpecEvo = 2
	setCamp("白鹰")
	canCopy = false

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "luoYingShenfu":
		luoYingShenfu()

func luoYingShenfu():
	for i in getAllChas(1):
		if i.get("camp") == "重樱" or i.get("camp") == "塞壬":
			azurHurtChara(i, byCount*0.5*(att.atk+att.mgiAtk), Chara.HurtType.PHY, Chara.AtkType.SKILL, "落樱神斧")

var byCount = 0
func _onBattleStart():
	._onBattleStart()
	byCount = 0
	for i in getAllChas(2):
		if i.hasBuff("b_washington") != null:continue
		if i.get("camp") == "白鹰":
			byCount += 1
			i.addBuff(b_washington.new(upgraded, true))
		else:
			i.addBuff(b_washington.new(upgraded, false))

class b_washington:
	extends Buff
	var buffName = "天佑白鹰"
	var dispel = 2
	var isBy = false
	func _init(upgraded = false, isBy = false):
		attInit()
		id = "b_washington"
		att.suck = 0.25
		att.mgiSuck = 0.25
		self.isBy = isBy
		if isBy:
			if upgraded:
				att.atkL = 0.15
				att.mgiAtkL = 0.15
	func _connect():
		if isBy:
			masCha.connect("onHurt",self,"_onHurt")
	func _onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 && not atkInfo.isMiss:
			atkInfo.hurtVal *= 0.85
		
			