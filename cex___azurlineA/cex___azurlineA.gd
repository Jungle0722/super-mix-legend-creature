extends "../cazurlineA_3_2/cazurlineA_3_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」江风·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	lv = 4             #等级的设置
	addSkill("每{cd}秒向前方依次发射3枚鱼雷，每枚鱼雷对直线上的敌人造成[法强*1.5]({damage})的可暴击技能伤害", "六莲雷", "liuLianLei", 10)

	addSkillTxt("[color=#C0C0C0][现代化改造]-六莲雷数量+3(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setCamp("重樱")
var baseId = ""

func liuLianLei():
	for i in range(p4):
		yield(reTimer(0.4),"timeout")
		ef()

func ef():
	utils.createSkillTextEff("六莲雷", position)
	if aiCha == null:
		var skill = getSkill("liuLianLei")
		skill.nowTime += 2
		return
	var eff2:Eff = sys.newEff("animEff", position)
	eff2.setImgs(direc + "eff/thunderFly", 9, true)
	eff2._initFlyPos(position + (aiCha.position - position).normalized() * 1000, 350)
	eff2.normalSpr.position=Vector2(0, -30)
	eff2.connect("onInCell",self,"effInCell")

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "liuLianLei" && aiCha != null:
		liuLianLei()

func effInCell(cell):
	var cha = matCha(cell)
	if cha == null:
		cha = matCha(cell + Vector2(0, 1))
	if cha != null && cha.team != team:
		azurHurtChara(cha, min(cha.att.maxHp*1.2, getSkillEffect("六莲雷")), Chara.HurtType.MGI, Chara.AtkType.SKILL, "六莲雷", true)

var p4 = 3
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	p4 = 5