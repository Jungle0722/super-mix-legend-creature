extends "../cazurlineD_2_3/cazurlineD_2_3.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」豪·誓约"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 3     #攻击力（每点代表8.5））
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("我方场上每有一名战列舰娘，提高双方10%攻击(注：豪自身提高战列舰数量*10%，其他角色提升10%)", "不朽之约")

	addSkillTxt("[color=#C0C0C0][现代化改造]-不朽之约还将提供攻速(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func _onBattleStart():
	._onBattleStart()
	for i in getAllChas(2):
		if i.get("type") == "bb":
			i.addBuff(buffUtil.b_atkL.new(1))
			addBuff(buffUtil.b_atkL.new(1))
			if upgraded:
				i.addBuff(buffUtil.b_spd.new(1))
				addBuff(buffUtil.b_spd.new(1))
