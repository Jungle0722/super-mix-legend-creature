extends "../cex___als-roon/cex___als-roon.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」罗恩·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("圣盾破裂时，对攻击者造成[双防*0.3]({damage})的真实伤害，并恢复等额血量", "爆反装甲")

	addSkillTxt("[color=#C0C0C0][现代化改造]-爆反装甲伤害系数+0.2(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var p4 = 0.3
func upgrade():
	p4 = 0.5
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func afterShengDun(cha):
	var num = (att.def+att.mgiDef)*p4
	azurHurtChara(cha, num, Chara.HurtType.REAL, Chara.AtkType.SKILL, "爆反装甲")
	healCha(cha, num)