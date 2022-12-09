extends "../cazurlineA_6_1/cazurlineA_6_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」伊卡洛斯·改"   #角色的名称
	attCoe.mgiAtk += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("本回合[非召唤]友军彻底阵亡时，召唤一个继承自身装备、属性、随机技能的镜像", "愿景")
	addSkillTxt("[color=#C0C0C0][现代化改造]-召唤的镜像获得本体当前义愤加成(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha) or isSumm or isDeath:return
	if cha.team == team and not cha.isSumm:
		if team == 2 and sys.rndPer(75):return
		var summ = summChara("cex___altmp-A611", true)
		summ.summoner = self
		if team == 1:
			summ.fromJson(toJson(), false)
			if upgraded:
				var bf = hasBuff("b_akasita")
				summ.addBuff(b_akasita.new(bf.att.mgiAtk))