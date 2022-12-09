extends "../cazurlineC_2/cazurlineC_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」波特兰"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.def += 1
	lv = 3             #等级的设置
	evos = ["cazurlineC_2_1_1"]
	addSkill("30%概率格挡伤害，本回合内每次成功格挡获得5%[吸血、暴击、爆伤]，上限200%", "防御号令")

	autoGetSkill()
	setCamp("白鹰")
var lv4Flag = false
var gdCount = 0
var geDangLv = 30
func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if sys.rndPer(geDangLv):
		if team == 2 and sys.rndPer(50):return
		atkInfo.hurtVal = 0
		gdCount += 1
		if lv4Flag and gdCount >= 5:
			fyzj()
			gdCount = 0
		var buff = hasBuff("b_btl_fyhl")
		if buff == null:
			addBuff(b_btl_fyhl.new())
		elif (buff.att.suck < 2 and team == 1) or (buff.att.suck < 1 and team == 2):
			buff.att.suck += 0.08
			buff.att.cri += 0.08
			buff.att.criR += 0.08
		if upgraded:
			.normalAtkChara(atkInfo.atkCha)

class b_btl_fyhl:
	extends Buff
	var buffName = "防御号令"
	func _init():
		attInit()
		id = "b_btl_fyhl"	
		att.suck = 0.08
		att.cri = 0.08
		att.criR = 0.08

func _onBattleEnd():
	._onBattleEnd()
	gdCount = 0

func fyzj():
	for i in getCellChas(aiCha.cell, 1, 1):
		createCustEff(sys.main.map.map_to_world(i.position), "eff/zhan", 6, false, 0.3, Vector2(0, -40))
		.normalAtkChara(i)
		if isAwaken:
			buffUtil.addLouShui(i, self, 5)
			i.addBuff(buffUtil.b_shaoShi.new(5))

func checkAwaken():
	for i in getAllChas(2):
		if i.chaName.find("印第安纳波利斯") > -1:
			i.awakenProcess += 1
			if i.awakenProcess >= 10 and not i.isAwaken:
				i.awaken()

func _onDeath(atkInfo):
	._onDeath(atkInfo)
	if isDeath:
		checkAwaken()