extends "../cex___alcamp-merkuria/cex___alcamp-merkuria.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」水星纪念·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("每{cd}秒:\n火>雷、冰：[天火]-对血量最低的敌人造成[攻击*火点数*1]的真实伤害\n雷>=火或冰：[磁暴]-对当前目标及周围2格的所有敌人造成[法强*雷点数*1]的技能伤害，并使其技能冷却时间延长[雷点数]秒\n冰>=雷或火：[冰墙]-使自己前方两列的所有敌人获得5层<霜冻>，并恢复自身[冰点数*血上限*10%]的血量\n火=雷=冰：[超声波]-向周围射出9道声波，对波及到的敌人造成[双攻*火雷冰点数*30%]的魔法伤害，并眩晕2秒", "元素反应", "sk_merkuria", 8)

	addSkillTxt("[color=#C0C0C0][现代化改造]-能量上限+1(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	maxEle = 4
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "sk_merkuria":
		sk_merkuria()

func sk_merkuria():
	if fire >= ice or fire >= thunder:
		utils.createSkillTextEff("天火", position)
		sk_fire()
	if thunder >= ice or thunder >= fire:
		utils.createSkillTextEff("磁暴", position)
		sk_thunder()
	if ice >= fire or ice >= thunder:
		utils.createSkillTextEff("冰墙", position)
		sk_ice()
	if ice == fire and fire == thunder:
		yield(reTimer(0.1),"timeout")
		sk_all()

#天火
func sk_fire():
	var cha = getFirstCha(1, "sortByHp")
	if cha != null:
		azurHurtChara(cha, att.atk*fire, Chara.HurtType.REAL, Chara.AtkType.SKILL, "天火")
#磁暴
func sk_thunder():
	if aiCha == null:return
	for i in getCellChas(aiCha.cell, 2, 1):
		azurHurtChara(i, att.mgiAtk*thunder*1, Chara.HurtType.MGI, Chara.AtkType.SKILL, "天火")
		for j in i.skills:
			j.nowTime-=thunder
#冰墙
func sk_ice():
	var cells = []
	for i in range(2):
		for j in range(6):
			cells.append(Vector2(cell.x + i + 1, j))
	for i in cells:
		var cha = matCha(i)
		if cha != null and cha.team != team:
			cha.addBuff(buffUtil.b_freeze.new(5))
	healCha(self, att.maxHp*ice*0.1)
#超声波
func sk_all():
	var chas = getAllChas(1)
	chas.shuffle()
	for i in range(9):
		if i >= chas.size():break
		var eff:Eff = newEff("sk_feiZhan",sprcPos)
		eff._initFlyPos(position + (chas[i].position - position).normalized() * 1200, 800)
		eff.connect("onInCell",self,"effInCell")
		yield(reTimer(0.1),"timeout")

func effInCell(cell):
	var cha = matCha(cell)
	if cha == null:
		cha = matCha(cell + Vector2(0, 1))
	if cha != null && cha.team != team:
		cha.addBuff(buffUtil.b_xuanYun.new(2))
		azurHurtChara(cha, (att.atk+att.mgiAtk)*(ice+fire+thunder)*0.3, Chara.HurtType.MGI, Chara.AtkType.SKILL, "超声波")