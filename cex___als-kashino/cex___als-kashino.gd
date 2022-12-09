extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「辅助」樫野"   #角色的名称
	attCoe.atkRan = 3#攻击距离
	attCoe.maxHp = 3#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 2     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 4  #魔法攻击（每点代表13.7）
	attCoe.def = 3     #物理防御（每点代表15）
	attCoe.mgiDef = 3#魔法防御（每点代表16.6）
	atkEff = "atk_dao" #攻击时的特效
	lv = 3             #等级的设置
	evos = ["cex___als-kashino2"]
	canCopy = false
	type2 = "doctor"
	addSkill("回合结束时，若自身没有死亡，则获得40金", "军备运输")
	addSkill("每{cd}秒清除所有友军的负面效果", "后勤支援", "darkWatch", 10)
	addSkill("周围2格的友军每秒60%概率获得2层<活力>", "战时维修")

	autoGetSkill()
	supportSpecEvo = 2
	setCamp("重樱")
	type = "dd"
	setGunAndArmor("小型","轻型")
	prefer = "ap"
var p3 = 40
func _castCdSkill(id):
	._castCdSkill(id)	
	if id == "darkWatch":
		darkWatch()
			
func darkWatch():
	var chas = getAllChas(2)
	for i in chas:
		for j in buffs:
			if j.isNegetive:
				j.isDel = true

var flag = true
func _onBattleEnd():
	._onBattleEnd()
	if flag and team == 1:
		sys.main.player.plusGold(p3)
	flag = true

func _upS():
	._upS()
	if sys.rndPer(60):
		var chas = getCellChas(cell, 2, 2)
		for i in chas:
			buffUtil.addHuoLi(i, self, 2)