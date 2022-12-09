extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」岛风"   #角色的名称
	attCoe.atkRan = 5#攻击距离
	attCoe.maxHp = 4#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 3     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 5  #魔法攻击（每点代表13.7）
	attCoe.def = 3     #物理防御（每点代表15）
	attCoe.mgiDef = 3#魔法防御（每点代表16.6）
	atkEff = "atk_dao" #攻击时的特效
	lv = 3             #等级的设置
	evos = ["cex___als-daofeng2"]
	canCopy = false
	type = "dd"
	addSkill("每{cd}秒发射一枚鱼雷对目标造成[法强*6]({damage})的魔法伤害", "特型鱼雷", "sk_daofeng1", 5)
	addSkill("每普攻4次，瞬移到随机敌方单位身边，对周围(九宫格)的敌人发射特型鱼雷", "电光石火")
	addSkill("将自身攻速的30%转化为法术穿透和法术吸血", "最速传说")
	setGunAndArmor("小型","轻型")
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("重樱")
	ename = "daofeng"
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="sk_daofeng1" and aiCha != null:
		sk_daofeng1()

func sk_daofeng1(cha = aiCha):
	if cha.isDeath:return
	createFlyEff(sprcPos, cha, "sk_feiDang")
	azurHurtChara(cha, att.mgiAtk*6, Chara.HurtType.MGI, Chara.AtkType.SKILL, "特型鱼雷")

var normalAtkNum = 0
func _onNormalAtk(cha):
	._onNormalAtk(cha)
	normalAtkNum += 1
	if normalAtkNum >= 4:
		normalAtkNum = 0
		dianGuangSH()

func dianGuangSH():
	var chas = getAllChas(1)
	chas.shuffle()
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
				for j in getAroundChas(cell, false):
					sk_daofeng1(j)
				if lv == 4:
					#迅光雷袭
					azurHurtChara(cha, att.mgiAtk*12, Chara.HurtType.MGI, Chara.AtkType.SKILL, "迅光雷袭")
				if upgraded:
					buffUtil.addShengDun(self, 2)
					addBuff(buffUtil.b_vague.new(2))
				return

func _onBattleStart():
	._onBattleStart()
	normalAtkNum = 0
	addBuff(b_daofeng.new())

func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "特型鱼雷":
		return att.mgiAtk * 6
	if name == "迅光雷袭":
		return att.mgiAtk * 12
		
class b_daofeng:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_daofeng"
	func _upS():
		att.mgiPenL = masCha.att.spd * 0.3
		att.mgiSuck = masCha.att.spd * 0.3