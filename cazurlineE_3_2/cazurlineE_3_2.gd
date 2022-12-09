extends "../cazurlineE_3/cazurlineE_3.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「航母」赤城"   #角色的名称
	attCoe.maxHp += 2
	lv = 3             #等级的设置
	attCoe.mgiDef += 1
	attCoe.mgiAtk += 2
	evos = ["cazurlineE_3_2_1"]
	addSkill("每{cd}秒给所有友军舰载机更换「穿甲航弹」或「高爆航弹」，更换后，自身陷入2秒脆弱状态", "命运的五分钟", "destinyMinutes", 8)

	addSkillTxt("[color=#C0C0C0][羁绊·一航战]-我方场上存在加贺时，先手必胜额外分别对两名敌人生效[/color]")
	autoGetSkill()
	itemEvoCha2 = "cex___almiu-akagi"
	setCamp("重樱")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="destinyMinutes":
		destinyMinutes()
var bs = [b_explosiveAmmo, b_piercingAmmo]
func destinyMinutes():
	utils.createSkillTextEff("命运的五分钟", position)
	addBuff(b_fragile.new(2))
	var chas = getAllChas(2)
	for i in chas:
		if i.isSumm:
			i.addBuff(bs[sys.rndRan(0, 1)].new(5))

class b_explosiveAmmo:
	extends Buff
	var buffName = "高爆航弹"
	func _init(lv = 1):
		attInit()
		id = "b_explosiveAmmo"	
		life = lv 
		att.atk = 50
	func _connect():
		masCha.connect("onAtkChara",self,"_onAtkChara")
	var cells = [Vector2(-1,0),Vector2(1,0),Vector2(0,1),Vector2(0,-1)]
	func _onAtkChara(atkInfo:AtkInfo):
		if atkInfo.atkType == Chara.AtkType.NORMAL:
			for i in cells:
				var mcha = masCha.matCha(atkInfo.hitCha.cell+i)
				if mcha != null && mcha.team != masCha.team:
					masCha.azurHurtChara(mcha, masCha.att.atk, Chara.HurtType.PHY, Chara.AtkType.EFF, "高爆航弹")

class b_piercingAmmo:
	extends Buff
	var buffName = "穿甲航弹"
	func _init(lv = 1):
		attInit()
		id = "b_piercingAmmo"	
		life = lv 
		att.penL = 0.75
		att.mgiPenL = 0.75

class b_fragile:
	extends Buff
	var buffName = "脆弱"
	func _init(lv = 1):
		attInit()
		id = "b_fragile"	
		isNegetive = true
		life = lv 
		att.defL = -0.5
		att.mgiDefL = -0.5

######################μ兵装相关######################
var p4 = 3
func _onBattleStart():
	._onBattleStart()
	jbFlag = 1
	for i in getAllChas(2):
		if i.chaName.find("加贺") > -1:
			jbFlag = 3
			break

func jiBan1():
	addBuff(buffUtil.b_cd.new(3))

func jiBan2():
	addBuff(buffUtil.b_maxHpL.new(2))

func jiBan3():
	p4 = 5
	
func finalAwaken():
	p4 = 7

func resetAwaken():
	p4 = 3