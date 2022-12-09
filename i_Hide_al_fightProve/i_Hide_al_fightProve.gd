extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[稀有]历战之证"
	att.atk = 0
	att.mgiAtk = 0
	att.maxHp = 0
	att.def = 0
	att.mgiDef = 0
	att.defR = 0
	info = """携带者受到物理伤害，本装备防御提升2点（上限400）
携带者受到法术伤害，本装备魔抗提升3点（上限400）
携带者受到真实伤害，本装备血量提升5点（上限600）
携带者造成物理伤害，本装备攻击提升1点（上限400）
携带者造成法术伤害，本装备法强提升4点（上限400）
携带者阵亡，本装备提升伤害减免1%（上限15%）
[color=#C0C0C0]特效不能被科研装备吞噬[/color]"""
var flag = true
func _upS():
	flag = true

func _connect():
	._connect()
	if masCha.team != 1:
		att.mgiAtk = 100
		att.atk = 100
		return
	masCha.connect("onAtkChara",self,"onAtkChara")
	masCha.connect("onHurt",self,"onHurt")
	masCha.connect("onDeath", self, "onDeath")
	sys.main.connect("onBattleStart",self,"start")

var enable = true
func start():
	enable = true	

func onDeath(atkInfo):
	if enable and att.defR < 0.15:
		enable = false
		att.defR += 0.01

func onAtkChara(atkInfo):
	if not flag:return
	flag = false
	if atkInfo.hurtType == Chara.HurtType.MGI && att.mgiAtk < 400:
		att.mgiAtk += 4
	elif atkInfo.hurtType == Chara.HurtType.PHY && att.atk < 400:
		att.atk += 1
	
func onHurt(atkInfo):
	if atkInfo.hurtType == Chara.HurtType.MGI && att.mgiDef < 400:
		att.mgiDef += 3
	elif atkInfo.hurtType == Chara.HurtType.PHY && att.def < 400:
		att.def += 2
	elif atkInfo.hurtType == Chara.HurtType.REAL && att.maxHp < 600:
		att.maxHp += 5