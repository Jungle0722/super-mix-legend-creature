extends "../cazurlineB_6_1/cazurlineB_6_1.gd"
func _info():
	pass
var baseId = ""
func _extInit():
	._extInit()
	chaName = "「轻巡」海王星·改"   #角色的名称
	attCoe.atk += 3     #攻击力（每点代表8.5）
	attCoe.maxHp += 1
	lv = 4             #等级的设置
	addSkill("每{cd}秒随机向30个单元格发射冰晶，被击中的友军恢复全部生命值，被击中的敌人受到[攻击*2]({damage})的伤害", "海之女神", "seaGod", 10)
	addSkillTxt("[color=#C0C0C0][现代化改造]-海之女神被击中的友军获得4层<活力>，被击中的敌人获得4层<漏水>(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setGunAndArmor("中型","中型")

func _castCdSkill(id):
    ._castCdSkill(id)
    if id=="seaGod":
        seaGod()

func seaGod():
	var cells = []
	utils.createSkillTextEff("海之女神", position)
	for i in range(30):
		var c = utils.getRndCell(0)
		while cells.has(c):
			c = utils.getRndCell(0)
			yield(reTimer(0.02),"timeout")
		cells.append(c)
	for i in cells:
		createCustEff(sys.main.map.map_to_world(i), "eff/bingCi", 15, false, 1.3, Vector2(0, -20))
		var cha = matCha(i)
		if cha != null:
			if cha.team == team:
				healCha(cha, cha.att.maxHp)
				if upgraded:
					buffUtil.addHuoLi(cha, self, 4)
			else:
				azurHurtChara(cha, getSkillEffect("海之女神"), Chara.HurtType.PHY, Chara.AtkType.SKILL, "海之女神")
				if upgraded:
					buffUtil.addLouShui(cha, self, 4)

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
