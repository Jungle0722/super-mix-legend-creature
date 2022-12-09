extends "../cazurlineA_1_2/cazurlineA_1_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」恶毒·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 3
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	attCoe.def += 1
	lv = 4             #等级的设置
	addSkill("每{cd}秒发射一枚恐怖的飞鱼导弹，对目标及2格范围内的敌方单位造成[法强*3]({damage})的可暴击伤害，并附加5层<烧蚀>", "飞鱼导弹", "sydd", 10)
	addSkillTxt("[color=#C0C0C0][现代化改造]-飞鱼导弹AOE范围+1，附加烧蚀20层(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "sydd" && aiCha != null:
		sydd()

func sydd():
	utils.createSkillTextEff("飞鱼导弹", position)
	# createDirectEff(aiCha.position, "sk_yunShi")
	createCustEff(aiCha.position, "eff/shenfa", 9, false, 1.8, Vector2(0, -55))
	var chas = getCellChas(aiCha.cell,p4,1)
	for i in chas: 
		azurHurtChara(i, getSkillEffect("飞鱼导弹"), Chara.HurtType.MGI, Chara.AtkType.SKILL, "飞鱼导弹", true)
		i.addBuff(utils.buffs.b_shaoShi.new(p4_2, self))

var p4 = 2
var p4_2 = 5
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	p4 = 3
	p4_2 = 20