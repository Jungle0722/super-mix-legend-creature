extends "../cex___almiu-tashkent/cex___almiu-tashkent.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「驱逐」塔什干·μ兵装"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4
	skillStrs.pop_back()
	addSkill("攻速提高[30%*我方μ兵装角色数]", "兵装解放")
	addSkillTxt(jbText)
	addSkillTxt("[color=#C0C0C0][现代化改造]-兵装解放同时提高暴击伤害(未解锁)")
	if isInManual():
		addSkillTxt("[color=#C0C0C0][兵装解放强化]-Lv1：每造成10次技能伤害，对目标周围2格造成[法强*3]的可暴击真实伤害，Lv2：兵装解放同时提高法强")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onBattleStart():
	._onBattleStart()
	addBuff(b_tashkent.new(miuNum, self))
	atkCount = 0

var atkCount = 0
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)	
	if atkInfo.atkType == Chara.AtkType.SKILL and p4 > 0:
		atkCount += 1
		if atkCount >= 10:
			atkCount = 0
			for i in getCellChas(atkInfo.hitCha.cell, 2, 1):
				azurHurtChara(i, att.mgiAtk*3, Chara.HurtType.REAL, Chara.AtkType.EFF, "兵装解放", true)

class b_tashkent:
	extends Buff
	var dispel = 2
	func _init(num = 1.0, cha = null):
		attInit()
		id = "b_tashkent"	
		att.spd = 0.3 * num
		if cha.upgraded:
			att.criR = 0.3 * num
		if cha.p4 == 2:
			att.mgiAtkL = 0.3 * num