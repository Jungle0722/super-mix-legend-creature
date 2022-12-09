extends "../cex___als-kii/cex___als-kii.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」纪伊·改"   #角色的名称
	attCoe.atkRan = 2
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2
	attCoe.def += 2
	attCoe.mgiDef += 2
	attCoe.mgiAtk += 2
	lv = 4             #等级的设置
	addSkill("<固化><先手>每10秒，连续突进到5名随机敌人身边发起斩击，造成[双攻双防之和]({damage})的可暴击普攻伤害，斩击\n过程中免疫伤害及负面效果", "无敌斩")
	addSkillTxt("[color=#C0C0C0][现代化改造]-无敌斩斩击次数+2(未解锁)")
	addSkillTxt("[color=#C0C0C0]在不断的无敌斩后，纪伊逐渐有了新的领悟...")
	if upgraded:
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()	
var p4 = 5
func upgrade():
	p4 = 7
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
var baseId = ""
var onZhan = false

func awaken(msg = true):
	chaName = "「战列」纪伊·觉醒"
	addSkill("无敌斩将对目标周围(九宫格范围)的敌人造成伤害", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "纪伊已经获得了心智觉醒！")
	isAwaken = true

func _onBattleEnd():
	._onBattleEnd()
	onZhan = false
	flag = 9

var flag = 9
func _upS():
	._upS()
	flag += 1
	if flag >= 10:
		wuDiZhan()
		flag = 0
	if not onZhan:return
	for j in buffs:
		if j.isNegetive and j.get("dispel") != 3:
			j.isDel = true

func wuDiZhan():
	awakenProcess += 1
	if awakenProcess >= 50 and not isAwaken:
		awaken()
	utils.createSkillTextEff("无敌斩", position)
	onZhan = true
	for i in range(p4):
		tuJi()
		yield(reTimer(1),"timeout")
	onZhan = false

func tuJi():
	for n in range(5):
		var target = utils.getRndEnemy(self)
		if target == null:continue
		var vs = [Vector2(0,0),Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1),Vector2(1,1),Vector2(-1,1),Vector2(-1,-1),Vector2(1,-1)]
		var mv = Vector2(target.cell.x, target.cell.y)
		for j in vs:
			var v = mv + j
			if matCha(v) == null && sys.main.isMatin(v) and setCell(v):
				var pos = sys.main.map.map_to_world(cell)
				ying(pos)
				position = pos
				createCustEff(sys.main.map.map_to_world(target.cell), "eff/zhan", 8, false, 0.3, Vector2(0, -70))
				aiCha = target
				azurHurtChara(target, getSkillEffect("无敌斩"), Chara.HurtType.PHY, Chara.AtkType.NORMAL, "无敌斩", true)
				if isAwaken:
					for i in getAroundChas(target.cell):
						azurHurtChara(i, getSkillEffect("无敌斩"), Chara.HurtType.PHY, Chara.AtkType.NORMAL, "无敌斩", true)
				return

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if onZhan:
		atkInfo.hurtVal = 0

func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "无敌斩":
		return att.mgiAtk+att.atk+att.def+att.mgiDef