extends "../cazurlineF_3/cazurlineF_3.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「辅助」黑暗界"   #角色的名称
	attCoe.atk += 2
	attCoe.maxHp += 1
	lv = 3             #等级的设置
	evos = ["cazurlineF_3_1_1"]
	addSkill("每次开炮，向正前方发射1轮弹幕，对受波及的敌人造成[物攻*1]({damage})的可暴击技能伤害", "弹幕·黑暗界")
	addSkill("若本轮弹幕未命中任何敌人，则随机变换一次位置", "快速转移")
	autoGetSkill()
	setCamp("皇家")

var px = 10
var p = 1
var p3 = 1
var damaged = false
var cells = []
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "fire":
		cast()
		yield(reTimer(0.3),"timeout")
		cast()

func effInCell(cell):
	var cha = matCha(cell)
	if cha != null && cha.team != team:
		var dmg = min(cha.att.maxHp*0.6, att.atk*p3)
		if team == 2:dmg *= 0.6
		azurHurtChara(cha, dmg, Chara.HurtType.PHY, Chara.AtkType.SKILL, "弹幕·黑暗界", true)
		damaged = true
		if isAwaken:
			cha.addBuff(buffUtil.b_freeze.new(10))

func cast():
	if team == 2:
		px = 0
		p = -1
	damaged = false
	var eff1:Eff = sys.newEff("animEff", sys.main.map.map_to_world(cell))
	eff1.setImgs(direc + "eff/thunderFly", 9, true)
	eff1._initFlyPos(sys.main.map.map_to_world(Vector2(px, cell.y)), 350)
	eff1.normalSpr.position=Vector2(0, -30)
	eff1.connect("onInCell",self,"effInCell")

	var eff2:Eff = sys.newEff("animEff", sys.main.map.map_to_world(cell+Vector2(-1*p, 1)))
	eff2.setImgs(direc + "eff/thunderFly", 9, true)
	eff2._initFlyPos(sys.main.map.map_to_world(Vector2(px+1, cell.y+1)), 350)
	eff2.normalSpr.position=Vector2(0, -30)
	eff2.connect("onInCell",self,"effInCell")

	var eff3:Eff = sys.newEff("animEff", sys.main.map.map_to_world(cell+Vector2(-1*p, -1)))
	eff3.setImgs(direc + "eff/thunderFly", 9, true)
	eff3._initFlyPos(sys.main.map.map_to_world(Vector2(px, cell.y-1)), 350)
	eff3.normalSpr.position=Vector2(0, -30)
	eff3.connect("onInCell",self,"effInCell")
	yield(reTimer(0.5),"timeout")
	if not damaged and team == 1:
		moveTo()
	damaged = false
func moveTo():
	if cells.empty():
		for i in range(2):
			for j in range(6):
				cells.append(Vector2(i, j))

	cells.shuffle()
	for i in cells:
		if i.y == cell.y:continue
		var cha = matCha(i)
		if cha == null:
			setCell(i)