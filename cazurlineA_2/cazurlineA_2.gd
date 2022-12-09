extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」沃克兰"   #角色的名称
	attCoe.atkRan = 1  #攻击距离
	attCoe.maxHp = 5   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 2     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 6  #魔法攻击（每点代表13.7）
	attCoe.def = 5     #物理防御（每点代表15）
	attCoe.mgiDef = 5  #魔法防御（每点代表16.6）
	attAdd.atkL = -0.2
	lv = 2             #等级的设置
	atkEff = "atk_dang"
	evos = ["cazurlineA_2_1", "cazurlineA_2_2"]
	addSkill("物攻降低20%，普攻附带[法强*0.5]({damage})的伤害，所有技能伤害可暴击", "高爆装药")
	addSkill("每{cd}秒尝试向敌方魔抗最低的单位发起突击，并获得2层<模糊><圣盾>", "冲锋号角", "cfhj", 5)
	setGunAndArmor("小型","轻型")
	setCamp("自由鸢尾")
	type = "dd"

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="cfhj":
		cfhj()

func cfhj():
	if team == 1:
		addBuff(buffUtil.b_vague.new(2))
	var chas = getAllChas(1)
	chas.sort_custom(self, "sort")
	var vs = [Vector2(0,0),Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1),Vector2(1,1),Vector2(-1,1),Vector2(-1,-1),Vector2(1,-1)]
	for cha in chas:
		if not unlock:
			azurHurtChara(cha, att.mgiAtk, Chara.HurtType.MGI, Chara.AtkType.SKILL, "冲锋号角-AI")
			return
		if cha.isDeath || cha.isSumm:continue
		var mv = Vector2(cha.cell.x ,cha.cell.y)
		for i in vs:
			var v = mv+i
			if matCha(v) == null && sys.main.isMatin(v) and setCell(v):
				var pos = sys.main.map.map_to_world(cell)
				ying(pos)
				position = pos
				aiCha = cha
				buffUtil.addShengDun(self, 2)
				return

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL:
		azurHurtChara(atkInfo.hitCha, getSkillEffect("高爆装药"), Chara.HurtType.MGI, Chara.AtkType.SKILL, "高爆装药")

func _onAtkInfo(atkInfo):
	._onAtkInfo(atkInfo)
	if atkInfo.atkCha == self && atkInfo.atkType == Chara.AtkType.SKILL:
		atkInfo.canCri = true

func sort(a, b):
	return a.att.mgiDef < b.att.mgiDef

func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "高爆装药":
		return att.mgiAtk * 0.5
	elif name == "剑刃风暴":
		return att.mgiAtk * 0.8
	elif name == "火力反击":
		return att.mgiAtk * 2
	elif name == "霜风":
		return att.mgiAtk * 0.1