extends "../cazurlineE/cazurlineE.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」龙凤"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___als-ryuho2"]
	addSkill("<唯一>战斗开始时在自己同行对称位置召唤一个强大的<龙卷风>(←点击可查看说明)", "龙卷风")
	addSkill("龙卷风会不断将附近5格的敌人吸拢过来", "风之力")
	ename = "longfeng"
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("重樱")
	canCopy = false
var eff = null
var effCell = null
var inCells = []
func _onBattleStart():
	._onBattleStart()
	for i in getAllChas(2):
		if i.has_method("initWind") and i != self and i.rndId > rndId:
			return
	initWind()

func initWind():
	effCell = Vector2(9 - cell.x, cell.y)
	getInCell()
	eff = sys.newEff("animEff", sys.main.map.map_to_world(effCell))
	eff.setImgs(direc + "eff/jianRenFengBao", 5, true)
	eff.scale *= 6
	eff.normalSpr.position = Vector2(0, -10)

func _upS():
	._upS()
	if effCell == null:return
	var cha = masCha.matCha(effCell)
	var dmg = att.atk * 0.8
	if upgraded:dmg *= 1
	if cha != null and cha.team != team:
		azurHurtChara(cha, dmg, Chara.HurtType.REAL, Chara.AtkType.SKILL, "龙卷风")
		cha.addBuff(buffUtil.b_xuanYun.new(1))
	var inChas = []	
	for i in getCellChas(effCell, 2, 1):
		azurHurtChara(i, dmg, Chara.HurtType.PHY, Chara.AtkType.SKILL, "龙卷风")
		inChas.append(i)
	for i in getCellChas(effCell, 5, 1):
		if inChas.has(i):continue
		for j in inCells:
			if matCha(j) == null:
				i.setCell(j)
				i.addBuff(buffUtil.b_xuanYun.new(1))
				break
	
func getInCell():
	inCells.clear()
	for i in utils.getAllCells(2):
		if cellRan(effCell, i) <= 2:
			inCells.append(i)
	inCells.sort_custom(self, "sort")

func sort(a, b):
	return cellRan(a, effCell) < cellRan(b, effCell)
	
func _onBattleEnd():
	._onBattleEnd()
	if is_instance_valid(eff):
		eff.queue_free()
	effCell = null
	inCells.clear()
