extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」苏维埃罗西亚"   #角色的名称
	attCoe.atkRan = 5#攻击距离
	attCoe.atk += 2     #攻击力（每点代表8.5）
	lv = 3             #等级的设置
	evos = ["cex___als-sovetskaya2"]
	addSkill("当身边(十字范围)没有任何非召唤队友时:射程+5，攻击+40%", "北极孤狼")
	addSkill("北方联合阵营的友军发起普攻时，立即对该目标支援一次普攻", "联合打击")

	autoGetSkill()
	supportSpecEvo = 2
	setCamp("北方联合")
	canCopy = false

func _onBattleStart():
	._onBattleStart()
	addBuff(b_sovetskaya.new())
	yield(reTimer(0.1),"timeout")
	for i in getAllChas(2):
		if (i.get("camp") == "北方联合" or i.get("campTmp") == "北方联合") and i.chaName.find("苏维埃罗西亚") == -1:
			i.addBuff(b_sovetskaya2.new(self))

func normalAtkChara(cha):
	if cha != aiCha:
		index += 1
	if index <= 4:
		.normalAtkChara(cha)

var index = 0
func _upS():
	._upS()
	index = 0

class b_sovetskaya:
	extends Buff
	var buffName = "北极孤狼"
	var dispel = 2
	func _init():
		attInit()
		id = "b_sovetskaya"
		att.atkRan = 5
		att.atkL = 0.4
	func _upS():
		if masCha.get("upgraded") == true:return
		if masCha.getNearChas(masCha.cell).empty() and masCha.aiCha != null:
			att.atkRan = 5
		else:
			att.atkRan = 0

#联合打击
class b_sovetskaya2:
	extends Buff
	var buffName = "联合打击"
	var cha
	var dispel = 2
	func _init(cha = null):
		attInit()
		id = "b_sovetskaya2"
		self.cha = cha
	func _connect():
		if masCha.chaName.find("苏维埃罗西亚") == -1:
			masCha.connect("onAtkChara",self,"run")
	func run(atkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL and not cha.isDeath:
			cha.normalAtkChara(atkInfo.hitCha)
	
	