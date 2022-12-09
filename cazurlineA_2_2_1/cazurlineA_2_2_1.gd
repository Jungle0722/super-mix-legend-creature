extends "../cazurlineA_2_2/cazurlineA_2_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」尼古拉斯·改"   #角色的名称
	attCoe.maxHp += 3   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 3
	lv = 4             #等级的设置
	addSkill("每{cd}秒，随机向四周放出十八道霜风，对接触到的敌人造成[法强*0.1]({damage})的伤害，并附带霜刃效果", "霜风", "frostWind", 12)
	addSkillTxt("[color=#C0C0C0][现代化改造]-霜风提高至24道(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setCamp("白鹰")

var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="frostWind":
		frostWind()

func frostWind():
	for i in range(p4):
		var pos=Vector2(sys.rndRan(-300,300),sys.rndRan(-300,300))
		var eff:Eff = newEff("sk_feiZhan",sprcPos)
		eff._initFlyPos(position + pos.normalized() * 400, 300)
		eff.connect("onInCell",self,"effInCell")
		yield(reTimer(0.15),"timeout")

func effInCell(cell):
	var cha = matCha(cell)
	if cha == null:
		cha = matCha(cell + Vector2(0, 1))
	if cha != null && cha.team != team:
		azurHurtChara(cha, getSkillEffect("霜风"), Chara.HurtType.MGI, Chara.AtkType.SKILL, "霜风")
		frostBlade(cha)

var p4 = 18
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	if team == 1:
		p4 = 24