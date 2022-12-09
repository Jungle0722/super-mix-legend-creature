extends "../cazurlineB/cazurlineB.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」恰巴耶夫"   #角色的名称\
	attCoe.atkRan = 4
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 2     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___als-chapayev2"]
	canCopy = false
	addSkill("每{cd}秒赋予当前目标3层<霜冻>并造成[法强*1.5]({damage})的技能伤害，20%概率追加[虚空白骑兵]技能", "精准诱导", "preciseInduction", 7)
	addSkill("当前目标周围两格的所有敌人获得3层<霜冻>，然后对其造成[霜冻层数*法强*1.5]的魔法伤害", "虚空白骑兵")

	autoGetSkill()
	supportSpecEvo = 2
	setCamp("北方联合")

var p3 = 20
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="preciseInduction" and aiCha != null:
		preciseInduction(aiCha)

func preciseInduction(cha = aiCha):
	if skFlag >= 2:return
	skFlag += 1
	cha.addBuff(buffUtil.b_freeze.new(3))
	azurHurtChara(cha, getSkillEffect("精准诱导"), Chara.HurtType.MGI, Chara.AtkType.SKILL, "精准诱导")
	if sys.rndPer(p3):
		whiteCavalry(cha)

var skFlag = 0
func _upS():
	._upS()
	skFlag = 0

func whiteCavalry(cha):
	for i in getCellChas(cha.cell, 2, 1):
		i.addBuff(buffUtil.b_freeze.new(3))
		buffUtil.addJuDu(i, self, 3)
		var buff = i.hasBuff("b_freeze")
		var num = 1
		if buff != null:num = buff.life
		azurHurtChara(i, att.mgiAtk * 1.5 * num, Chara.HurtType.MGI, Chara.AtkType.SKILL, "虚空白骑兵")

