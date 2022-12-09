extends "../cazurlineB_1/cazurlineB_1.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「轻巡」蒙彼利埃"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 2     #攻击力（每点代表8.5）
	lv = 3             #等级的设置
	evos = ["cex___azurlineB"]
	addSkill("<先手>每8秒向距离最远的敌人投掷一个大宝贝，使其[眩晕]2秒，在效果结束时，若目标身边存在\n						其他队友，则随机弹向其队友，最多弹射4次", "所罗门传说", "slmcs", 8)
	autoGetSkill()
	setCamp("白鹰")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="slmcs":
		slmcs()

func slmcs():
	utils.createSkillTextEff("所罗门传说", position)
	var chas=getAllChas(1)
	chas.sort_custom(self,"sortByDistanceDesc")
	createFlyEff(sprcPos, chas[0], "sk_4_1_2")
	chas[0].addBuff(utils.buffs.b_tantanle.new())
	
func _onBattleStart():
	._onBattleStart()
	slmcs()


