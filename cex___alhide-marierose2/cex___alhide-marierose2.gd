extends "../cex___alhide-marierose/cex___alhide-marierose.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」玛丽萝丝·改"   #角色的名称
	attCoe.mgiAtk += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("战斗开始时，使2名非塞壬敌方单位<退化>", "群体退化")

	addSkillTxt("[color=#C0C0C0][现代化改造]-被汲取的敌人技能冷却速度降低100%，被治疗的友军获得1层<活力>(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onBattleStart():
	._onBattleStart()
	for i in range(2):
		var cha = getFirstCha(1, "sortByLvDesc", true)
		if cha != null:
			var cha1 = sys.main.newChara(sys.rndListItem(utils.get("lv%d"%[max(1, cha.lv - 1)])), 2)
			for j in cha.items:
				var it = sys.newItem(j.id)
				if it.has_method("toJson"):
					it.fromJson(j.toJson())
				cha1.addItem(it)
			var c = cha.cell
			sys.main.delMatChara(cha)
			sys.main.map.add_child(cha1)
			sys.main.setMatCha(c, cha1)
			cha1.position = sys.main.map.map_to_world(c)
			cha1.newEff("sk_zhao")