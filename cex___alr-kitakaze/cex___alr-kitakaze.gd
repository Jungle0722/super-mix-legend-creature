extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「驱逐」北风"
	attCoe.atkRan = 3  #攻击距离
	attCoe.maxHp = 5   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 1
	attCoe.mgiAtk = 3     #攻击力（每点代表8.5）
	attCoe.def = 3     #物理防御（每点代表15）
	attCoe.mgiDef = 3     #物理防御（每点代表15）
	lv = 3
	atkEff = "atk_dao" #攻击时的特效
	isResearch = true
	addSkill("受到的伤害可以由法强来抵消，最多抵消80%伤害", "相位护盾")
	addSkill("每{cd}秒发射一枚相位鱼雷，对目标一排的所有敌人造成[法强*1.5]({damage})的神圣伤害，\n					当剩余冷却大于2秒时，每受到1次伤害，减少1秒冷却", "相位鱼雷", "phaseTorpedo", 10)
	autoGetSkill()
	
	setCamp("重樱")
	evos = ["cex___alr-kitakaze2"]
	canCopy = false
	supportSpecEvo = 2
	type = "dd"
	setGunAndArmor("小型", "轻型")
	prefer = "ap"
	ename = "beifeng"

var num = 0
func _castCdSkill(id):
	._castCdSkill(id)	
	if id == "phaseTorpedo":
		phaseTorpedo()

func _onBattleEnd():
	._onBattleEnd()
	num = 0

func phaseTorpedo():
	if aiCha != null:
		var eff:Eff = newEff("sk_chuanTouJian",sprcPos)
		eff._initFlyPos(position + (aiCha.position - position).normalized() * 1000,250)
		eff.connect("onInCell",self,"effInCell")

func effInCell(cell):
	var cha = matCha(cell)
	if cha == null:
		cha = matCha(cell + Vector2(0, 1))
	if cha != null && cha.team != team:
		var dmg = getSkillEffect("相位鱼雷")
		if lv == 4:
			dmg += min(num, att.mgiAtk*20)
			num *= 0.5
		if isAwaken:dmg *= 1.3
		if cha.get("type") == "BOSS":
			dmg = min(cha.att.maxHp*0.1, dmg)
		holyDmg(cha, dmg, "相位鱼雷")
		if upgraded:
			healCha(self, dmg*0.5)
		

func _onHurt(atkInfo):
	var diff = atkInfo.hurtVal * 0.8 - att.mgiAtk
	if diff > 0:
		atkInfo.hurtVal = diff
		num += att.mgiAtk
	else:
		num += atkInfo.hurtVal * 0.8
		atkInfo.hurtVal *= 0.2
	._onHurt(atkInfo)
	var sk = getSkill("phaseTorpedo")
	if sk.cd/(1 + att.cd) - sk.nowTime >= 2:
		sk.nowTime += 2

func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "相位鱼雷":
		return att.mgiAtk * 2