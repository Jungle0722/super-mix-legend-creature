extends "../azurline_base_item/azurline_rare_item.gd"
func init():
	.init()
	name = "[稀有]高能磁铁"
	info = "每4秒，将周围3格的敌人向自身吸附，并赋予其1秒眩晕\n[color=#DC143C]同时装备两件时可升级[/color]\n[color=#C0C0C0]特效可被科研装备吞噬[/color]"
	price = 300
	att.atk = 100
	att.mgiAtk = 100
	att.def = 120
	att.mgiDef = 120
	att.dod = 0.3
	
var index = 0
func _upS():
	if masCha == null or not utils.inBattle(masCha):return
	index += 1
	if index >= 4:
		index = 0

		var inCells = []
		for i in utils.getAllCells(2):
			if masCha.cellRan(masCha.cell, i) <= 3:
				inCells.append(i)
		inCells.sort_custom(self, "sort")
		for i in masCha.getCellChas(masCha.cell, 3, 1):
			for j in inCells:
				if masCha.matCha(j) == null:
					i.setCell(j)
					i.addBuff(buffUtil.b_xuanYun.new(1))
					break	

func sort(a, b):
	return masCha.cellRan(a, masCha.cell) < masCha.cellRan(b, masCha.cell)

