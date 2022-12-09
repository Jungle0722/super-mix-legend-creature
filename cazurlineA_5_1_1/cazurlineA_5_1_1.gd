extends "../cazurlineA_5_1/cazurlineA_5_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」凉月·花嫁"   #角色的名称
	attCoe.mgiAtk += 1
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	attCoe.def += 1
	lv = 4             #等级的设置
	addSkill("普攻附带的法伤会溅射给给周围2格的敌人", "连环打击")
	addSkillTxt("[color=#C0C0C0][现代化改造]-造成技能伤害时有10%概率对该敌人发射一枚重型鱼雷(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if sys.rndPer(10) and atkInfo.atkType == Chara.AtkType.SKILL:
		zxyl(atkInfo.hitCha)