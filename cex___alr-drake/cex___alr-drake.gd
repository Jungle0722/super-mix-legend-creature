extends "../cazurlineC/cazurlineC.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「重巡」德雷克"
	attCoe.atkRan = 3  #攻击距离
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 4     #攻击力（每点代表8.5）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2     #物理防御（每点代表15）
	lv = 3
	isResearch = true

	addSkill("每普攻3次，对目标周围(九宫格范围)的敌人造成[物攻*2]({damage})的技能伤害，并附加4层[流血]", "雷霆一击")
	addSkill("身上每有一件装备，造成的伤害提高20%，攻击自己的敌人每有一件装备，受到的伤害降低15%", "武器大师")
	addSkill("战斗开始时，<掠夺>一名随机敌方单位身上的全部装备", "强行掠夺")

	autoGetSkill()
	setCamp("皇家")
	evos = ["cex___alr-drake2"]
	canCopy = false
	supportSpecEvo = 2
var p4_1 = 0.2
var p4_2 = 0.15
var atkNum = 0
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		atkNum += 1
		if atkNum >= 3:
			atkNum = 0
			var dmg = getSkillEffect("雷霆一击")
			for i in aroundCells:
				var cha = matCha(atkInfo.hitCha.cell+i)
				if cha != null && cha.team != team:
					azurHurtChara(cha, dmg, Chara.HurtType.PHY, Chara.AtkType.SKILL, "雷霆一击")
					cha.addBuff(buffUtil.b_liuXue_r.new(4))
	
	atkInfo.factor += items.size() * p4_1

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	atkInfo.hurtVal *= 1-atkInfo.atkCha.items.size()*p4_2

var itemList = []
func _onBattleStart():
	._onBattleStart()
	var chas = getAllChas(1)
	var cha
	for i in range(chas.size()):
		if chas[i].items.size() == 0:continue
		cha = chas[i]

	if cha == null || cha.items.size() == 0:return
	var attr = BaseAttr.new(cha.items)
	addBuff(b_lveDuo.new(attr))

	for i in cha.items:
		itemList.append(i.id)

	var index = cha.items.size() - 1
	while(index >= 0):
		cha.delItem(cha.items[index])
		index -= 1
	
func _onBattleEnd():
	._onBattleEnd()
	atkNum = 0
	if itemList.size() > 0 && sys.rndPer(10):
		for i in itemList:
			sys.main.player.addItem(i)

	itemList = []
	
class b_lveDuo:
	extends Buff
	var buffName = "掠夺"
	func _init(attr:BaseAttr):
		attInit()
		id = "b_lveDuo"
		att.atk = attr.atk
		att.atkL = attr.atkL
		att.mgiAtk = attr.mgiAtk
		att.mgiAtkL = attr.mgiAtkL
		att.def = attr.def
		att.defL = attr.defL
		att.mgiDef = attr.mgiDef
		att.mgiDefL = attr.mgiDefL
		att.spd = attr.spd
		att.cri = attr.cri

		att.suck = attr.suck
		att.mgiSuck = attr.mgiSuck
		att.dod = attr.dod
		att.criR = attr.criR
		att.pen = attr.pen
		att.mgiPen = attr.mgiPen
		att.penL = attr.penL
		att.mgiPenL = attr.mgiPenL

class BaseAttr:
	var atk = 0
	var atkL = 0
	var mgiAtk = 0
	var mgiAtkL = 0
	var def = 0
	var defL = 0
	var mgiDef = 0
	var mgiDefL = 0
	var spd = 0
	var cri = 0

	var suck = 0
	var mgiSuck = 0
	var dod = 0
	var criR = 0
	var pen = 0
	var mgiPen = 0
	var penL = 0
	var mgiPenL = 0
	func _init(items):
		for i in items:
			atk += i.att.atk
			atkL += i.att.atkL
			mgiAtk += i.att.mgiAtk
			mgiAtkL += i.att.mgiAtkL
			def += i.att.def
			defL += i.att.defL
			mgiDef += i.att.mgiDef
			mgiDefL += i.att.mgiDefL
			spd += i.att.spd
			cri += i.att.cri

			suck += i.att.suck
			mgiSuck += i.att.mgiSuck
			dod += i.att.dod
			criR += i.att.criR
			pen += i.att.pen
			mgiPen += i.att.mgiPen
			penL += i.att.penL
			mgiPenL += i.att.mgiPenL