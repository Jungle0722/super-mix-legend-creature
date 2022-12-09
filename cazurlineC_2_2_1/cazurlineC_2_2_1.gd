extends "../cazurlineC_2_2/cazurlineC_2_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」阿尔及利亚·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5））
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("<限定>生命值低于50%触发，5秒内嘲讽周围2格的单位且受到的伤害转为回血，\n				效果结束时，对全体敌方单位造成[目标烧蚀层数*回血量]的物理伤害", "背水一战")
	addSkill("每{cd}秒瞬移到敌方护甲最高的单位身旁并对其发起攻击，并赋予10层<烧蚀><漏水>", "破甲一击", "zcxj", 8)

	addSkillTxt("[color=#C0C0C0][现代化改造]-破甲一击现在会赋予20层烧蚀并追加2次普攻(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setCamp("自由鸢尾")

var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="zcxj":
		zcxj()

func zcxj():
	var chas = getAllChas(1)
	chas.sort_custom(self, "sort1")
	var vs = [Vector2(0,0),Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1),Vector2(1,1),Vector2(-1,1),Vector2(-1,-1),Vector2(1,-1)]
	for cha in chas:
		if cha.isDeath || cha.isSumm:continue
		var mv = Vector2(cha.cell.x ,cha.cell.y)
		for i in vs:
			var v = mv+i
			if matCha(v) == null && sys.main.isMatin(v) and setCell(v):
				var pos = sys.main.map.map_to_world(cell)
				ying(pos)
				position = pos
				aiCha = cha
				cha.addBuff(buffUtil.b_shaoShi.new(10, self))
				buffUtil.addLouShui(cha, self, 10)
				if upgraded:
					cha.addBuff(buffUtil.b_shaoShi.new(10, self))
					if not cha.isDeath:
						.normalAtkChara(cha)
						.normalAtkChara(cha)
				return

func sort1(a,b):
	return  a.att.def > b.att.def

#是否可以施放技能
var flag = true
#回血量
var num = 0

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if flag && att.hp/att.maxHp < 0.5:
		utils.createSkillTextEff("背水一战", position)
		addBuff(b_NuHuoLianFeng.new())
		flag = false
		for i in getCellChas(cell, 2, 1):
			i.addBuff(buffUtil.b_taunt.new(5, self))
			i.aiCha = self
	if hasBuff("b_NuHuoLianFeng"):
		num += atkInfo.hurtVal
		atkInfo.hurtVal=0

func _onBattleEnd():
	._onBattleEnd()
	attAdd.atk = 0
	num = 0
	flag = true

class b_NuHuoLianFeng:
	extends Buff
	var buffName = "背水一战"
	var dispel = 2
	func _init():
		attInit()
		id = "b_NuHuoLianFeng"
		life = 5
	func _del():
		._del()
		masCha.healCha(masCha, masCha.num)
		for i in masCha.getAllChas(1):
			var bf = i.hasBuff("b_shaoShi")
			if bf != null:
				masCha.azurHurtChara(i, min(i.att.maxHp*1.2, masCha.num*bf.life), Chara.HurtType.PHY, Chara.AtkType.SKILL, "背水一战")

var p4 = 2
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	p4 = 4