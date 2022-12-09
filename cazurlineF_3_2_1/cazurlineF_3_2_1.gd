extends "../cazurlineF_3_2/cazurlineF_3_2.gd"
func _info():
	pass
func _connect():
	._connect()
	pass

func _extInit():
	._extInit()
	chaName = "「辅助」恐怖·誓约"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2
	lv = 4             #等级的设置
	addSkill("每{cd}秒对目标直线发射一轮恐怖的光束轰击，造成[物攻*5]({damage})的可暴击伤害，附加5层<烧蚀>", "光能主炮", "lightGun", 8)

	addSkillTxt("[color=#C0C0C0][现代化改造]-光能主炮伤害提高100%，且附带5层漏水效果(未解锁)")
	addSkillTxt("[color=#C0C0C0]在一次次的开炮后，恐怖逐渐有了恐怖的领悟...")
	if upgraded:
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()
var p4 = 5
func upgrade():
	p4 = 10
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")

func awaken(msg = true):
	chaName = "「辅助」恐怖·觉醒"
	addSkill("光能主炮额外附带8层烧蚀与漏水效果", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "恐怖已经获得了心智觉醒！")
	isAwaken = true

var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "lightGun":
		lightGun()

func lightGun():
	var eff:Eff = newEff("sk_jiGuan", sprcPos)
	eff.sprLookAt(aiCha.global_position)
	eff.scale *= 1.5
	eff.position = position
	var chas = utils.lineChas(cell, aiCha.cell, 10)
	for cha in chas:
		if cha.team != team:
			azurHurtChara(cha, att.atk*p4, Chara.HurtType.MGI, Chara.AtkType.SKILL, "光能主炮", true)
			cha.addBuff(buffUtil.b_shaoShi.new(5))
			if upgraded:
				buffUtil.addLouShui(cha, self, 5)
			if isAwaken:
				buffUtil.addLouShui(cha, self, 8)
				cha.addBuff(buffUtil.b_shaoShi.new(8))