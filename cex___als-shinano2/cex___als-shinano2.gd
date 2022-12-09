extends "../cex___als-shinano/cex___als-shinano.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」信浓·花嫁"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("每{cd}秒引导我方所有舰载机，使其各自对其当前目标造成[(信浓法强+舰载机双攻)*0.3]的真实伤害", "星夜之云", "starCloud", 10)
	addSkillTxt("[color=#C0C0C0][现代化改造]-星夜之云伤害系数+0.15(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var p4 = 0.3
func upgrade():
	p4 = 0.45
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "starCloud":
		starCloud()

func starCloud():
	utils.createSkillTextEff("星夜之云", position)
	var chas = getAllChas(2)
	for i in chas:
		if i.isSumm and i.aiCha != null:
			var d:Eff = i.newEff("sk_feiDang",i.sprcPos)
			d._initFlyCha(i.aiCha)
			i.yieldOnReach(d)
			azurHurtChara(i.aiCha, (att.mgiAtk+i.att.atk+i.att.mgiAtk)*p4, Chara.HurtType.REAL, Chara.AtkType.SKILL, "星夜之云")
			