extends "../cazurlineB_2_1/cazurlineB_2_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「轻巡」神通·改"   #角色的名称
	attCoe.atk += 2     #攻击力（每点代表8.5）
	attCoe.maxHp += 2
	lv = 4             #等级的设置
	addSkill("每次普攻有概率召唤一名继承自身全部装备、随机技能、属性的镜像", "两手准备")
	addSkillTxt("[color=#C0C0C0][现代化改造]-战斗开始时直接召唤一名镜像，召唤镜像赋予1秒无敌(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setGunAndArmor("中型","中型")
	setCamp("重樱")

var baseId = ""
var p4 = 22
func _onNormalAtk(cha):
	if not is_instance_valid(cha):return
	._onNormalAtk(cha)
	if sys.rndPer(p4):
		if not unlock:
			addBuff(buffUtil.b_jiSu_r.new(20))
		else:
			p4 = max(8, p4 - 2)
			lszb()

func lszb():
	var cha = summChara("cex___altmp-D221", true)
	cha.summoner = self
	cha.fromJson(toJson(), false)
	if upgraded:
		cha.addBuff(buffUtil.b_wudi.new(1))

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func _onBattleStart():
	._onBattleStart()	
	if upgraded:
		lszb()

func _onBattleEnd():
	._onBattleEnd()	
	p4 = 22