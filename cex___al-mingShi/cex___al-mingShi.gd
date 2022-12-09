extends "../cazurlineF/cazurlineF.gd"
func _info():
	pass
var baseId = ""
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「辅助」明石·撒币型"   #角色的名称
	lv = 4             #等级的设置
	attCoe.maxHp += 3   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 1     #攻击力（每点代表8.5）
	attCoe.def += 3     #物理防御（每点代表15）
	attCoe.mgiDef += 3  #魔法防御（每点代表16.6）

	addSkill("战斗开始时，玩家每拥有100金，提高15%法强", "氪金就能变强")
	addSkill("每{cd}秒向血量最低的4名敌人撒币，每次花费5金，造成[法强*4]({damage})的魔法伤害", "撒币战术", "sbzs", 7)
	addSkill("每击杀一名非召唤敌人，回收15金", "炼铜术")

	addSkillTxt("[color=#C0C0C0][现代化改造]-撒币战术伤害提高75%(未解锁)")
	setCamp("重樱")
	autoGetSkill()
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var p4 = 4
func upgrade():
	p4 = 7
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "sbzs":
		sbzs()

func _onKillChara(atkInfo):
	._onKillChara(atkInfo)	
	if atkInfo.hitCha.isSumm:return
	sys.main.player.plusGold(15)

func _onBattleStart():
	._onBattleStart()
	addBuff(b_mingshi.new((sys.main.player.gold/100.0) * 1.5))

func sbzs():
	var chas = getAllChas(1)
	chas.sort_custom(self,"sortByHp")
	for i in range(4):
		if i >= chas.size():break
		var dmg = att.mgiAtk*p4
		azurHurtChara(chas[i], dmg, Chara.HurtType.MGI, Chara.AtkType.SKILL, "撒币战术")
		sys.main.player.plusGold(-5)

class b_mingshi:
	extends Buff
	var dispel = 2
	var buffName = "氪金就能变强"
	func _init(num = 1.0, duration = 0):
		attInit()
		id = "b_mingshi"	
		if num < 0:
			isNegetive = true
		att.mgiAtkL = 0.1 * num
		if duration > 0:
			life = duration
		else:
			id += "_p"