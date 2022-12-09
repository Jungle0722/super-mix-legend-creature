extends "../azurline_ctrl/TBF.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	attCoe.mgiAtk += 1
	chaName = "「鱼雷机」TBD蹂躏者·VT-8中队"   #角色的名称
	lv = 4             #等级的设置
	addSkillTxt("每9秒对前方3行的所有敌人造成[法强*2]的伤害")
	addCdSkill("sk", 9)

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "sk":
		cast()
	
var baseId = ""
var px = 10
var p = 1
func cast():
	if team == 2:
		px = 0
		p = -1

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

func effInCell(cell):
	var cha = matCha(cell)
	if cha != null && cha.team != team:
		hurtChara(cha, min(cha.att.maxHp*0.8, att.mgiAtk*2), Chara.HurtType.MGI, Chara.AtkType.SKILL)