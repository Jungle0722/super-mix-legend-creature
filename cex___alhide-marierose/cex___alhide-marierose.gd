extends "../cazurlineA/cazurlineA.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」玛丽萝丝"   #角色的名称
	attCoe.mgiAtk += 2  #魔法攻击（每点代表13.7）
	attCoe.mgiDef += 2
	attCoe.maxHp += 1
	lv = 3             #等级的设置
	evos = ["cex___alhide-marierose2"]
	canCopy = false
	type = "dd"
	addSkill("每{cd}秒召唤一名随机友军的镜像(继承该友军装备)", "水镜术", "sk_marierose1", 5)
	addSkill("<先手>链接攻击最高的非塞壬敌方单位，使其与自身都无法普攻，每秒汲取其10%血量治疗血量最低的友军，\n					若该单位死亡，则再次发动灵魂汲取", "灵魂汲取")
	ename = "maliluosi"
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("其他")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="sk_marierose1":
		sk_marierose1()
#水镜术
func sk_marierose1():
	var chas = getAllChas(2)
	chas.erase(self)
	if not chas.empty():
		var rndCha = sys.rndListItem(chas)
		var cha = rndCha.summChara(rndCha.id, true)
		if cha.has_method("upgrade") and rndCha.get("upgraded") == true:
			cha.upgrade()
			cha.upgraded = true

func _onBattleStart():
	._onBattleStart()
	soulSuck()

func soulSuck():
	var cha = getFirstCha(1, "sortByAtkDesc", true)
	if cha != null:
		cha.addBuff(b_marierose.new(self))

func normalAtkChara(cha):
	pass
	
class b_marierose:
	extends Buff
	var buffName = "灵魂汲取"
	var dispel = 2
	var cha
	func _init(cha):
		attInit()
		id = "b_marierose"
		self.cha = cha
	var eff2
	var utils = globalData.infoDs["g_azurlineUtils"]

	func _upS():
		cha.azurHurtChara(masCha, masCha.att.maxHp*0.1, Chara.HurtType.REAL, Chara.AtkType.EFF, "灵魂汲取")
		var ally = cha.getFirstCha(2, "sortByHp")
		if ally != null:
			cha.healCha(ally, masCha.att.maxHp*0.1)
			if cha.upgraded:
				cha.buffUtil.addHuoLi(ally, cha, 1)

	func _connect():
		._connect()
		masCha.aiOn = false
		masCha.connect("onDeath",self,"onDeath")
		if cha.upgraded:
			att.cd = -1

	func _del():
		._del()
		masCha.aiOn = true

	func onDeath(atkInfo):
		cha.soulSuck()