extends "../cex___als-kaga/cex___als-kaga.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」加贺"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 1     #攻击力（每点代表8.5））
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("造成非普攻伤害时，有3%的几率使目标受到[80%目标血上限]的神圣伤害", "攻无不取", null, null, skillStrs.size()-1)

	addSkillTxt("[color=#C0C0C0][羁绊·一航战]-我方场上存在赤城时，先手必胜额外分别对两名敌人生效[/color]")
	addSkillTxt("[color=#C0C0C0][现代化改造]-攻无不取触发概率+2%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var p4 = 3
func upgrade():
	p4 = 5
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType != Chara.AtkType.NORMAL && sys.rndPer(p4):
		var dmg = maxHp(atkInfo.hitCha) * 0.8
		if atkInfo.hitCha.get("type") == "BOSS":
			dmg = min(atkInfo.hitCha.att.maxHp*0.1, dmg)
		atkInfo.hitCha.forceHurtSelf(dmg)
		increDmgNum(dmg, "攻无不取", atkInfo.hitCha)

