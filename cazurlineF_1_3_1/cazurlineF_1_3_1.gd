extends "../cazurlineF_1_3/cazurlineF_1_3.gd"
func _info():
	pass
func _connect():
	._connect()
var allCell = []
func _extInit():
	._extInit()
	chaName = "「辅助」U81·改"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 3
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("每{cd}秒使我方所有潜艇舰娘的潜射鱼雷立即装填完毕", "集群打击", "jiqunDj", 10)

	addSkillTxt("[color=#C0C0C0][羁绊·水下战队]-场上每有一艘其他不同型号的潜艇舰娘，提高20%冷却、20%法术穿透")
	addSkillTxt("[color=#C0C0C0][现代化改造]-目标定位额外赋予100%法术吸血(未解锁)")
	addSkillTxt("[color=#C0C0C0]U37、U47、U81、大青花鱼并肩战斗，终将觉醒...")
	if upgraded:
		skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	if isAwaken:
		awaken()
func upgrade():
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")

func awaken(msg = true):
	chaName = "「辅助」U81·觉醒"
	addSkill("我方所有潜艇舰娘的潜射鱼雷造成的伤害提高200%", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken:
		sys.newBaseMsg("事件", "U81已经获得了心智觉醒！")
	isAwaken = true

var baseId = ""
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "jiqunDj":
		for i in getAllChas(2):
			if utils.isSubMarine(i):
				var sk = i.getSkill("qsyl")
				sk.nowTime = sk.cd

func _onBattleStart():
	._onBattleStart()
	var types = utils.checkSubMarineTypes(self)
	types.erase("U81")
	if types.size() > 0:
		addBuff(buffUtil.b_jb_ss.new(types.size()))
	if types.size() >= 3:
		awakenProcess += 1
		if awakenProcess >= 21 and not isAwaken:
			call("awaken")