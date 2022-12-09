extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」维托里奥·维内托"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 3
	attCoe.def += 2
	attCoe.mgiDef += 2
	attCoe.atkRan = 4
	attAdd.penL += 1
	attAdd.cri += 0.2
	lv = 3             #等级的设置
	evos = ["cex___als-veneto2"]
	canCopy = false
	addSkill("护甲穿透提高100%，暴击提高30%", "嗑药炮")
	addSkill("<唯一>我方铁血阵营的舰娘(含召唤物)造成伤害时，20%的概率使该伤害提高150%", "帝国雄心")
	ename = "weineituo"
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("铁血")
	setGunAndArmor("大型","重型")

func _upS():
	._upS()
	for i in getAllChas(2):
		if i.hasBuff("b_veneto") != null:continue
		if i.get("camp") == "铁血":
			i.addBuff(b_veneto.new())
		elif upgraded and i.get("camp") == "重樱":
			i.addBuff(b_veneto.new())

class b_veneto:
	extends Buff
	var buffName = "帝国雄心"
	var dispel = 2
	func _init():
		attInit()
		id = "b_veneto"
	func _connect():
		masCha.connect("onAtkChara",self,"onAtkChara")
	func onAtkChara(atkInfo:AtkInfo):
		if sys.rndPer(20):
			atkInfo.hurtVal *= 2.5