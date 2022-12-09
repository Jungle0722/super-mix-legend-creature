extends "../cazurlineB_3_1/cazurlineB_3_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」能代·花嫁"   #角色的名称
	attCoe.atk += 4     #攻击力（每点代表8.5）
	attCoe.maxHp += 2
	lv = 4             #等级的设置
	addSkill("每闪避13次，对前方一行一列的所有敌人造成一次普攻", "新锐之刃")
	addSkillTxt("[color=#C0C0C0][现代化改造]-新锐之刃需要的闪避次数-5(未解锁)")
	addSkillTxt("[color=#C0C0C0]在闪避突破极限后，能代逐渐有了新的领悟...")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()
var baseId = ""
func awaken(msg = true):
	chaName = "「轻巡」能代·觉醒"
	addSkill("战斗开始时，从容指顾直接获得一半上限的属性叠加", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "能代已经获得了心智觉醒！")
	isAwaken = true	

func _onBattleStart():
	._onBattleStart()	
	if att.dod > 1.2 and not isAwaken and team == 1:
		awaken()

func normalAtkChara(tcha):
	if not is_instance_valid(tcha):return
	if missNum >= p4:
		missNum = 0
		var p = 1
		if team == 2:
			p = -1
		utils.createSkillTextEff("新锐之刃", position)
		createCustEff(position, "eff/xuanZhuanDaoGuang", 15, false, 1.8, Vector2(0, -20))

		for i in utils.getAllCells(1):
			if i.y == cell.y && (i.x - cell.x)*p > 0 || i.x == cell.x + p:
				createCustEff(sys.main.map.map_to_world(i), "eff/zhan", 6, false, 0.3, Vector2(0, -40))
				var cha = matCha(i)
				if cha != null && cha.team != team:
					.normalAtkChara(cha)
	.normalAtkChara(tcha)

var p4 = 13
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	p4 = 8