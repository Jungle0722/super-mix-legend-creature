extends "../cazurlineE_3_2_1/cazurlineE_3_2_1.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「航母」赤城·μ兵装"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5））
	attCoe.mgiAtk += 2
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	addSkill("造成魔法伤害时，额外附带3层<烧蚀><灼烧>", "兵装解放")
	addSkillTxt("[color=#C0C0C0][μ羁绊]-战斗开始时，场上μ兵装舰娘数量达到2/5/8个时，分别获得：20%冷却加成/20%血量加成/兵装解放技能强化[/color]")
	addSkillTxt("[color=#C0C0C0][羁绊·一航战]-我方场上存在加贺时，先手必胜额外分别对两名敌人生效[/color]")
	addSkillTxt("[color=#C0C0C0][现代化改造]-每次恶作剧将重复施展[μ兵装舰娘人数*0.8]次(向下取整)(未解锁)")
	if isInManual():
		addSkillTxt("[color=#C0C0C0][兵装解放强化]-Lv1：额外2层负面效果，Lv2：额外4层负面效果")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
		
	prefer = "ap"
	ename = "chicheng"
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.hurtType == Chara.HurtType.MGI:
		atkInfo.hitCha.addBuff(buffUtil.b_shaoShi.new(3))
		atkInfo.hitCha.addBuff(buffUtil.b_shaoZhuo_r.new(3))