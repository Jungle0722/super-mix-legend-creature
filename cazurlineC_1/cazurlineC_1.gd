extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「重巡」摩耶"   #角色的名称
	attCoe.atkRan = 2#攻击距离
	attCoe.maxHp = 5#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 6     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 2  #魔法攻击（每点代表13.7）
	attCoe.def = 3     #物理防御（每点代表15）
	attCoe.mgiDef = 3#魔法防御（每点代表16.6）
	lv = 2             #等级的设置
	evos = ["cazurlineC_1_1", "cazurlineC_1_2"]
	addSkill("开局闪现至同行最后一格，立即发射一轮鱼雷，并获得6层<圣盾><模糊>", "斩首行动")
	addSkill("每{cd}秒发射一枚重型鱼雷，对目标敌方单位造成[攻击*3]({damage})的可暴击物理伤害，并恢复同等数值的生命值", "鱼雷连射", "gx_ylls", 5)
	type = "ca"
	setGunAndArmor("中型","中型")
	setCamp("重樱")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="gx_ylls":
		gx_ylls()

func gx_ylls():
	if aiCha != null:
		createFlyEff(sprcPos, aiCha, "sk_4_1_2")
		var dmg = getSkillEffect("鱼雷连射")

		if ename == "jiuyuan" and (isSumm and get("summoner").upgraded or upgraded):
			azurHurtChara(aiCha, dmg, Chara.HurtType.REAL, Chara.AtkType.SKILL, "鱼雷连射", true)
		else:
			azurHurtChara(aiCha, dmg, Chara.HurtType.PHY, Chara.AtkType.SKILL, "鱼雷连射", true)

		if team == 1 or type == "BOSS":
			healCha(self, dmg)

func _onBattleStart():
	._onBattleStart()
	gx_zsxd()

func gx_zsxd():
	if not unlock:return
	yield(reTimer(0.45), "timeout")

	var mv = Vector2(cell.x ,cell.y)
	if team == 1:mv.x = 8
	else:mv.x = 0
	var vs = [Vector2(0,0),Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1),Vector2(1,1),Vector2(-1,1),Vector2(-1,-1),Vector2(1,-1),
	Vector2(0,2),Vector2(0,-2),Vector2(0,3),Vector2(0,-3)]
	for i in vs:
		var v = mv+i
		if matCha(v) == null && sys.main.isMatin(v):
			if setCell(v) :
				var pos = sys.main.map.map_to_world(cell)
				ying(pos)
				position = pos
				aiCha = null
				break		
	buffUtil.addShengDun(self, 6)
	if team == 1:
		addBuff(buffUtil.b_vague.new(6))
	var sk = getSkill("gx_ylls")
	sk.nowTime += sk.cd

func sort1(a,b):
	if team == 1:
		if a.cell.x < 6 && b.cell.x >= 6:
			return false
	else:
		if a.cell.x > 3 && b.cell.x <= 3:
			return false
	if a.get("type") == "BOSS" && b.get("type") != "BOSS":
		return false
	if a.att.atk + a.att.mgiAtk > b.att.atk + b.att.mgiAtk:
		return true
	return false

func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "鱼雷连射":
		return att.atk * 3
	elif name == "余烬":
		return att.atk * 0.5