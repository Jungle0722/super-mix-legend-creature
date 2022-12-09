extends "../cazurlineB_3/cazurlineB_3.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「轻巡」确捷"   #角色的名称
	attCoe.maxHp += 1
	attCoe.atk += 1
	lv = 3             #等级的设置
	evos = ["cazurlineB_3_2_1"]
	addSkill("开局闪现至同行最后一格，强制最近的敌方单位和自己决斗，并为周围(九宫格范围)的敌人附加5层<剧毒>", "胜利之剑")
	autoGetSkill()
	setCamp("皇家")
func slzj():
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

				var chas = getAllChas(1)
				chas.sort_custom(self, "sortByDistance")
				var cha = chas[0]
				if cha != null:
					cha.aiCha = self
					aiCha = cha
				for j in getAroundChas(cell, false):
					buffUtil.addJuDu(j, self, 5)
				break


func _onBattleStart():
	._onBattleStart()
	if team == 2 && hasBuff("b_zsxd_ai") == null:
		addBuff(b_zsxd_ai.new())
	slzj()

class b_zsxd_ai:
	extends Buff
	func _init():
		attInit()
		id = "b_zsxd_ai"
		att.spd = 0.3
		att.atkRan = 2