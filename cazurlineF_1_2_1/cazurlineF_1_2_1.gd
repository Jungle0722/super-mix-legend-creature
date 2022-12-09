extends "../cazurlineF_1_2/cazurlineF_1_2.gd"
func _info():
	pass
func _connect():
	._connect()
var allCell = []
func _extInit():
	._extInit()
	chaName = "「辅助」大青花鱼·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 3
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("发射鱼雷后，追加一枚重型鱼雷，对目标造成[法强*10]({damage})的可暴击伤害，并附加15层<漏水>", "陨落双鲨")

	addSkillTxt("[color=#C0C0C0][羁绊·水下战队]-场上每有一艘其他不同型号的潜艇舰娘，提高20%冷却、20%法术穿透")
	addSkillTxt("[color=#C0C0C0][现代化改造]-陨落双鲨额外对两名随机敌人追加重型鱼雷(未解锁)")
	addSkillTxt("[color=#C0C0C0]U37、U47、U81、大青花鱼并肩战斗，终将觉醒...")
	if upgraded:
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	setCamp("白鹰")
	if isAwaken:
		awaken()
#陨落双鲨伤害系数
var p4 = 1
func upgrade():
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")

func awaken(msg = true):
	chaName = "「辅助」大青花鱼·觉醒"
	addSkill("陨落双鲨伤害提高100%", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "大青花鱼已经获得了心智觉醒！")
	isAwaken = true
	p4 = 2

var baseId = ""
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "qsyl" && aiCha != null:
		doSk(aiCha)
		if upgraded:
			for i in range(2):
				var cha = utils.getRndEnemy(self)
				if cha != null and not cha.isDeath:
					doSk(cha)

func doSk(cha):
	createFlyEff(sprcPos, cha, "sk_feiDang")
	buffUtil.addLouShui(cha, self, 15)
	azurHurtChara(cha, getSkillEffect("陨落双鲨") * p4, Chara.HurtType.MGI, Chara.AtkType.SKILL, "陨落双鲨", true)

func _onBattleStart():
	._onBattleStart()
	var types = utils.checkSubMarineTypes(self)
	types.erase("大青花鱼")
	if types.size() > 0:
		addBuff(buffUtil.b_jb_ss.new(types.size()))
	if types.size() >= 3:
		awakenProcess += 1
		if awakenProcess >= 21 and not isAwaken:
			call("awaken")