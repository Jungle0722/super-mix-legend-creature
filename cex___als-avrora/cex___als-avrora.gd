extends "../cazurlineB/cazurlineB.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」阿芙乐尔"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___als-avrora2"]
	canCopy = false

	addSkill("<唯一>战斗开始时，将最靠前的敌人，与随机3个敌人捆绑，其中1人受到非特效伤害，\n				所有被捆绑者皆受到25%的特效伤害", "命运束缚")
	addSkill("使我方所有北方联合阵营的舰娘伤害提高50%，所有铁血、塞壬阵营的敌人获得50%易伤", "北方联合舰队")

	autoGetSkill()
	supportSpecEvo = 2
	setCamp("北方联合")
var p3_1 = 1.5
var p3_2 = 0.5
func _onBattleStart():
	._onBattleStart()
	var chas = getAllChas(1)
	chas.sort_custom(self, "sortByFront")

	var bindChas = []
	bindChas.append(chas.pop_front())
	chas.shuffle()
	for i in chas:
		if bindChas.size() >= 4:break
		bindChas.append(i)
	for i in bindChas:
		if i.hasBuff("b_avrora") == null:
			i.addBuff(b_avrora.new(bindChas, self))

class b_avrora:
	extends Buff
	var buffName = "命运束缚"
	var dispel = 2
	var bindChas = []
	var cha
	func _init(bindChas = [], cha = null):
		attInit()
		self.bindChas = bindChas
		self.cha = cha
		id = "b_avrora"
	func _connect():
		masCha.connect("onHurt",self,"_onHurt")
	func _onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 && not atkInfo.isMiss and not bindChas.empty() and atkInfo.atkType != Chara.AtkType.EFF:
			for i in bindChas:
				if not i.isDeath:
					cha.azurHurtChara(i, atkInfo.atkVal*0.25, atkInfo.hurtType, Chara.AtkType.EFF, "命运束缚")
var index = 0
func _upS():
	._upS()
	index += 1
	if index >= 2:
		index = 0
		for i in getAllChas(1):
			if i.hasBuff("b_avrora2") == null and (i.get("camp") == "铁血" or i.get("campTmp") == "铁血" or i.get("camp") == "塞壬" or i.get("campTmp") == "塞壬"):
				i.addBuff(b_avrora2.new(p3_1))
		for i in getAllChas(2):
			if i.hasBuff("b_avrora3") == null and (i.get("camp") == "北方联合" or i.get("campTmp") == "北方联合"):
				i.addBuff(b_avrora3.new(p3_2))

class b_avrora2:
	extends Buff
	var buffName = "北方联合舰队-易伤"
	var dispel = 2
	var num = 1
	var p1 = 1.5
	func _init(p = 1.5):
		attInit()
		id = "b_avrora2"
		self.p1 = p
	func _connect():
		masCha.connect("onHurt",self,"_onHurt")
	func _onHurt(atkInfo:AtkInfo):
		if atkInfo.hurtVal > 0 && not atkInfo.isMiss:
			atkInfo.hurtVal *= p1

class b_avrora3:
	extends Buff
	var buffName = "北方联合舰队-伤害加成"
	var dispel = 2
	var num = 1
	func _init(p = 0.5):
		attInit()
		id = "b_avrora3"
		att.atkR = p