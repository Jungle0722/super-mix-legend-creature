extends "../cazurlineC_4_3/cazurlineC_4_3.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」埃克塞特·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.atk += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("对敌人造成伤害时，若目标身上的<烧蚀>超过10层，引爆全部层数，并对周围1格的敌人造成[烧蚀层数*攻击*0.5]的物理技能伤害", "连锁爆炸")

	addSkillTxt("[color=#C0C0C0][现代化改造]-连锁爆炸伤害提高50%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""
var skFlag2 = true
func upgrade():
	p4 = 1.5
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var p4 = 1
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType != Chara.AtkType.EFF:
		var bf = atkInfo.hitCha.hasBuff("b_shaoShi")
		if bf == null:return
		if bf.life > 10 and skFlag2:
			skFlag2 = false
			for i in getCellChas(atkInfo.hitCha.cell, 1, 1):
				azurHurtChara(i, bf.life * att.atk * 0.5 * p4, Chara.HurtType.PHY, Chara.AtkType.SKILL, "连锁爆炸")
		bf.isDel = true		

func _upS():
	._upS()		
	skFlag2 = true