extends "../cex___als-sovetskaya/cex___als-sovetskaya.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」苏维埃罗西亚·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("满血时，普攻对目标直线上的敌人造成[物攻*0.5]的技能伤害并附加3层<霜冻>", "冰结锋芒")

	addSkillTxt("[color=#C0C0C0][现代化改造]-北极孤狼移除限制，冰结锋芒无需满血且伤害翻倍(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var p4 = 0.5
func upgrade():
	p4 = 1
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL and (att.hp / att.maxHp > 0.9 or upgraded):
		qx(atkInfo.hitCha)

func qx(cha):
	var eff:Eff = newEff("sk_feiZhan",sprcPos)
	eff._initFlyPos(position + (cha.position - position).normalized() * 1200, 800)
	eff.connect("onInCell",self,"effInCell")

func effInCell(cell):
	var cha = matCha(cell)
	if cha == null:
		cha = matCha(cell + Vector2(0, 1))
	if cha == null:
		cha = matCha(cell + Vector2(0, -1))
	if cha != null && cha.team != team:
		azurHurtChara(cha, att.atk*p4, Chara.HurtType.PHY, Chara.AtkType.SKILL, "冰结锋芒")
		cha.addBuff(buffUtil.b_freeze.new(3))
