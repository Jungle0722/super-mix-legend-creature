extends "../cazurlineF_2_1/cazurlineF_2_1.gd"
func _info():
	pass
func _connect():
	._connect()
var allCell = []
func _extInit():
	._extInit()
	chaName = "「辅助」明石·老板娘"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	lv = 4             #等级的设置
	addSkill("回合结束时获得一个补给箱，有概率开出普通装备、PT点、稀有装备、技能书", "补给箱")

	addSkillTxt("[color=#C0C0C0][现代化改造]-奸商还将额外提供玩家经验值收益(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	setCamp("重樱")

func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

var baseId = ""
#普通装备、50PT点、稀有装备、技能书、轮空
var rnds = [12, 12, 12, 4, 60]
func _onBattleEnd():
	._onBattleEnd()
	if team == 1:
		var rnd = sys.rndRan(1, 100)
		if rnd <= rnds[0]:
			#普通装备
			print("老板娘补给箱开启成功：获得普通装备")
			sys.main.player.addItem(utils.getRndItem())
		elif rnd <= rnds[0] + rnds[1]:
			#50PT
			print("老板娘补给箱开启成功：获得50PT")
			azurCtrl.pt += 50
		elif rnd <= rnds[0] + rnds[1] + rnds[2]:
			#稀有装备
			print("老板娘补给箱开启成功：获得稀有装备")
			sys.main.player.addItem(sys.newItem(utils.getRandomItem("RARE")))
		elif rnd <= rnds[0] + rnds[1] + rnds[2] + rnds[3]:
			#技能书
			print("老板娘补给箱开启成功：获得技能书")
			utils.getRandomSkillBook()