extends Item

func init():
	name = "闪烁匕首"
	type = config.EQUITYPE_EQUI
	attInit()
	att.atkL = 0.01
	att.mgiAtkL = 0.01
	att.spd = 0.01
	info = "闪烁到当前威胁最高的单位附近(仅玩家有效)"

func _connect():
	sys.main.connect("onBattleStart",self,"StartBattle")

var Genco = [Vector2(0,0),Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1),Vector2(1,1),Vector2(-1,1),Vector2(-1,-1),Vector2(1,-1)]

func StartBattle():
	if masCha.team == 1:
		var enemyChas = masCha.getAllChas(1)
		enemyChas.sort_custom(self,"Sort")
		if enemyChas[0] != null:
			for i in Genco:
				var Location = enemyChas[0].cell + i
				if (masCha.matCha(Location) == null && sys.main.isMatin(Location)) :
					if masCha.setCell(Location):
						var pos = sys.main.map.map_to_world(masCha.cell)
						Shadow(pos,masCha.position,masCha)
						masCha.position = pos
						masCha.aiCha = null
						break

func Shadow(pos,position,cha):
	var l:Vector2 = pos - position
	var s = 25
	var rs = preload("res://core/ying.tscn")
	var n = l.length()/s
	for i in range(n):
		var spr = rs.instance()
		sys.main.map.add_child(spr)
		spr.texture = cha.img.texture_normal
		spr.position = position + s * (i+1) * l.normalized() - Vector2(cha.img.texture_normal.get_width()/2,cha.img.texture_normal.get_height())
		spr.init(255/n * i + 100)

func Sort(a,b):
	if (a.att.atk + a.att.mgiAtk) > (b.att.atk + b.att.mgiAtk):
		return true
	return false

