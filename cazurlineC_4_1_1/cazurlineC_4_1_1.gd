extends "../cazurlineC_4_1/cazurlineC_4_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」扎拉·誓约"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.atk += 2  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("每次普攻赋予敌方单位5层随机负面效果", "弹药后效")
	addSkillTxt("[color=#C0C0C0][现代化改造]-本回合每普攻一次提高1%减伤，每受到一次攻击降低1%减伤(上限70%下限15%)(未解锁)")
	addSkillTxt("[color=#C0C0C0]一次又一次的射击，扎拉逐渐有了新的领悟...")
	if upgraded:
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()

func awaken(msg = true):
	chaName = "「重巡」扎拉·觉醒"
	addSkill("战斗开始时，主炮校正立即完成一半上限的属性叠加", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "扎拉已经获得了心智觉醒！")
	isAwaken = true	

var baseId = ""
var p4 = 0.85

func _onBattleEnd():
	._onBattleEnd()
	p4 = 0.85

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.hurtVal > 5:
		atkInfo.hurtVal *= p4
		p4 = clamp(p4 + 0.01, 0, 0.85)

func _onNormalAtk(cha):
	if not is_instance_valid(cha):return
	awakenProcess += 1
	if awakenProcess > 500 and not isAwaken:
		awaken()
	._onNormalAtk(cha)
	p4 = clamp(p4 - 0.01, 0, 0.85)
	if not cha.isDeath:
		buffUtil.addRndDebuff(self, cha, 5)

func upgrade():
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")