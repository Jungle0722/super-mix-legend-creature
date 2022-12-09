extends "../cex___planeBase/cex___planeBase.gd"
func _info():
	pass
func _connect():
	._connect()
	pass
func _extInit():
	._extInit()
	chaName = "通用战斗机"   #角色的名称
	attCoe.atkRan = 1  #攻击距离
	attCoe.def += 5
	attCoe.mgiDef += 5
	attCoe.maxHp += 4
	attCoe.atk -= 1
	attAdd.atkR -= 0.2
	attAdd.defR += 0.1
	addCdSkill("tujin", 6)
	addSkillTxt("每6秒尝试向血量最低的敌方单位发起突击")
	prefer = "fighter"

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "tujin":
		tujin()
		
func tujin():
	var chas = getAllChas(1)
	chas.sort_custom(self, "sortByHp")
	var vs = [Vector2(0,0),Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1),Vector2(1,1),Vector2(-1,1),Vector2(-1,-1),Vector2(1,-1)]
	for cha in chas:
		if cha.isDeath || cha.isSumm:continue
		var mv = Vector2(cha.cell.x ,cha.cell.y)
		for i in vs:
			var v = mv+i
			if matCha(v) == null && sys.main.isMatin(v) and setCell(v):
				var pos = sys.main.map.map_to_world(cell)
				# ying(pos)
				position = pos
				aiCha = cha
				return




