extends "../cazurlineB_2_3/cazurlineB_2_3.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」纽伦堡·改"   #角色的名称
	attCoe.atk += 4     #攻击力（每点代表8.5）
	attCoe.maxHp += 2
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("普攻附带3层<霜冻>，且有12%的几率清除目标身上的所有增益与装备", "火力压制")
	addSkillTxt("[color=#C0C0C0][现代化改造]-火力覆盖攻击目标+1(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setGunAndArmor("中型","中型")

var baseId = ""

func _onNormalAtk(cha):
	if not is_instance_valid(cha):return
	._onNormalAtk(cha)
	cha.addBuff(buffUtil.b_freeze.new(3))
	if sys.rndPer(12):
		for j in cha.buffs:
			if not j.isNegetive && j.get("dispel") != 2 and j.get("dispel") != 3:
				if cha.team == 2:
					cha.delBuff(j)
				else:
					cha.addBuff(buffUtil.b_liuXue_r.new(2))
			
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	p3 = 4