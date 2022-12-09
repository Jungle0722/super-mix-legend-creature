extends "../cex___warship/cex___warship.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「驱逐」绫波·Lv2"   #角色的名称
	attCoe.atkRan = 2#攻击距离
	attCoe.maxHp = 3#最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk = 3     #攻击力（每点代表8.5）
	attCoe.mgiAtk = 2  #魔法攻击（每点代表13.7）
	attCoe.def = 3     #物理防御（每点代表15）
	attCoe.mgiDef = 3#魔法防御（每点代表16.6）
	lv = 2             #等级的设置
	atkEff = "atk_dao" #攻击时的特效
	evos = ["cex___al-ayanami2"]
	addSkill("战斗开始时，若自身站位最靠前，则获得10层<暴露>，若位于最后一列，则获得4秒<狂化>", "蓄势待发")
	addSkill("<先手>每{cd}秒突进到护甲最低的敌人身边，获得3层<模糊>并赋予目标6层<暴露><流血>，自身受到来自该单位以外\n			的所有伤害降低60%", "所罗门鬼神", "slmgs", 6)
	type = "dd"
	setGunAndArmor("小型","轻型")
	prefer = "ad"
	setCamp("重樱")
	supportSpecEvo = 2
	
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="slmgs":
		slmgs()
var tjCha
func slmgs():
	addBuff(buffUtil.b_vague.new(3))
	var chas = getAllChas(1)
	chas.sort_custom(self, "sortByDef")
	var vs = [Vector2(0,0),Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1),Vector2(1,1),Vector2(-1,1),Vector2(-1,-1),Vector2(1,-1)]
	for cha in chas:
		if cha.isDeath || cha.isSumm:continue
		var mv = Vector2(cha.cell.x ,cha.cell.y)
		for i in vs:
			var v = mv+i
			if matCha(v) == null && sys.main.isMatin(v) and setCell(v):
				var pos = sys.main.map.map_to_world(cell)
				ying(pos)
				position = pos
				aiCha = cha
				tjCha = cha
				buffUtil.addBaoLu(tjCha, 6)
				tjCha.addBuff(buffUtil.b_liuXue_r.new(6))
				return

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkCha != tjCha:
		atkInfo.hurtVal *= 0.4

func _onBattleStart():
	._onBattleStart()
	if cell.x == 0:
		addBuff(buffUtil.b_spd.new(20, 5))
	var cha = getFirstCha(2, "sortByFront")
	if cha.cell.x <= cell.x:
		buffUtil.addBaoLu(self, 10)
	
	yield(reTimer(0.45),"timeout")
	slmgs()

func _onBattleEnd():
	._onBattleEnd()
	tjCha = null

func getSkillEffect(name):
	.getSkillEffect(name)
	if name == "鬼神演舞":
		return att.atk * 3.5
