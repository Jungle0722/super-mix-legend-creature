extends "../cazurlineE_1/cazurlineE_1.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「航母」胜利"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 1     #攻击力（每点代表8.5）
	lv = 3             #等级的设置
	evos = ["cex___azurlineE"]
	addSkill("<固化>每10秒赋予全体队友3层<活力>，吟唱16次后，消灭所有敌人", "胜利之歌")

	autoGetSkill()
	setGunAndArmor("小型","中型")
	setCamp("皇家")
var limit = 16	
var sing = 0
var p3 = 3

var flag = 0
func _upS():
	._upS()
	flag += 1
	if flag >= 10:
		slzg()
		flag = 0

func _onBattleEnd():
	._onBattleEnd()
	flag = 0
	sing = 0

func _castCdSkill(id):
	._castCdSkill(id)
	if sing >= limit && team == 1 || sing >= limit + 2 && team == 2:
		var chas = getAllChas(1)
		for i in chas:
			forceKillCha(i)

func slzg():
	utils.createSkillTextEff("胜利之歌", position)
	var chas = getAllChas(2)
	for i in chas:
		buffUtil.addHuoLi(i, self, p3)
	sing += 1