extends "../cazurlineC_6_1/cazurlineC_6_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」巴尔的摩·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.atk += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("每{cd}秒完全释放自身护盾，对全场敌人造成[护盾值*0.5]的物理特效伤害", "护盾猛击", "shieldAtk", 10)

	addSkillTxt("[color=#C0C0C0][现代化改造]-护盾猛击伤害提高50%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func _castCdSkill(id):
    ._castCdSkill(id)
    if id=="shieldAtk":
        shieldAtk()
#护盾猛击伤害系数
var p4 = 0.5
func shieldAtk():
	for i in getAllChas(1):
		azurHurtChara(i, shield*0.5, Chara.HurtType.PHY, Chara.AtkType.EFF, "护盾猛击")
	changeShield(-shield)

var baseId = ""
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	p4 = 0.75