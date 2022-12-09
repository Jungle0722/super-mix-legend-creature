extends "../cazurlineF_1_1/cazurlineF_1_1.gd"
func _info():
	pass
func _connect():
	._connect()
var allCell = []
func _extInit():
	._extInit()
	chaName = "「辅助」U47·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 3
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("每{cd}秒智能选取一个单元格并将所有敌人向该点吸聚，被移动距离越远，伤害越高，被赋予的结霜层数也越高", "大西洋空洞", "dxykd", 10)

	addSkillTxt("[color=#C0C0C0][羁绊·水下战队]-场上每有一艘其他不同型号的潜艇舰娘，提高20%冷却、20%法术穿透")
	addSkillTxt("[color=#C0C0C0][现代化改造]-大西洋空洞还将赋予敌人<漏水>效果(未解锁)")
	addSkillTxt("[color=#C0C0C0]U37、U47、U81、大青花鱼并肩战斗，终将觉醒...")
	if upgraded:
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	for i in range(0, 10):
		for j in range(0, 6):
			allCell.append(Vector2(i, j))
	allCell.sort_custom(self, "sort2")
	setCamp("铁血")
	if isAwaken:
		awaken()
#大西洋空洞伤害系数
var p4 = 1
func upgrade():
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")

func awaken(msg = true):
	chaName = "「辅助」U47·觉醒"
	addSkill("大西洋空洞伤害提高100%", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "U47已经获得了心智觉醒！")
	isAwaken = true
	p4 = 2

var baseId = ""
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "dxykd":
		dxykd()

func _onBattleStart():
	._onBattleStart()
	var types = utils.checkSubMarineTypes(self)
	types.erase("U47")
	if types.size() > 0:
		addBuff(buffUtil.b_jb_ss.new(types.size()))
	if types.size() >= 3:
		awakenProcess += 1
		if awakenProcess >= 21 and not isAwaken:
			call("awaken")

var cell1 = Vector2(8, 2)
var cell2 = Vector2(1, 2)

func dxykd():
	utils.createSkillTextEff("大西洋空洞", position)
	var index = 0
	if team == 1:
		playEff(cell1)
	else:
		playEff(cell2)
	var chas = getAllChas(1)
	chas.sort_custom(self, "sort")
	for i in chas:
		for j in range(index, allCell.size()):
			if j >= allCell.size():break
			index += 1
			if matCha(allCell[j]) == null:
				var r = min(4, cellRan(i.cell, allCell[j]))
				if team == 1:
					i.setCell(allCell[j])
					r = 1
				azurHurtChara(i, min(i.att.maxHp*1.2, r * att.mgiAtk * 0.35 * p4), Chara.HurtType.MGI, Chara.AtkType.SKILL, "大西洋空洞")
				i.addBuff(buffUtil.b_xuanYun.new(1))
				i.addBuff(buffUtil.b_freeze.new(r*1.5))
				if upgraded:
					buffUtil.addLouShui(i, self, r*3)
				break
		
func playEff(cell):
	createCustEff(sys.main.map.map_to_world(cell), "eff/jiaodizha", 8, false, 2, Vector2(0, -20))
	yield(reTimer(0.4),"timeout")

func sort(a, b):
	if team == 1:
		return cellRan(a.cell,cell1) > cellRan(b.cell,cell1)
	elif team == 2:
		return cellRan(a.cell,cell2) > cellRan(b.cell,cell2)

func sort2(a, b):
	if team == 1:
		return cellRan(a,cell1) < cellRan(b,cell1)
	elif team == 2:
		return cellRan(a,cell2) < cellRan(b,cell2)