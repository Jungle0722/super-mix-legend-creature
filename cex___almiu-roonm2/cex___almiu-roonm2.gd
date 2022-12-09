extends "../cex___almiu-roonm/cex___almiu-roonm.gd"
func _info():
	pass
func _connect():
	._connect()
func _extInit():
	._extInit()
	chaName = "「重巡」罗恩·μ兵装"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 4
	skillStrs.pop_back()
	addSkill("圣盾破裂时，50%概率使相邻(九宫格范围)队友获得1层圣盾", "兵装解放")
	addSkillTxt(jbText)
	addSkillTxt("[color=#C0C0C0][现代化改造]-兵装解放影响范围+2，圣盾层数+1(未解锁)")
	if isInManual():
		addSkillTxt("[color=#C0C0C0][兵装解放强化]-Lv1：双防提高50%，Lv2：额外对攻击者造成[双防*μ兵装舰娘人数*20%]的真实伤害")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""
func afterShengDun(cha):
	if sys.rndPer(50):return
	if p4 == 3:
		var num = (att.def + att.mgiDef) * miuNum * 0.2
		azurHurtChara(cha, num, Chara.HurtType.REAL, Chara.AtkType.SKILL, "兵装解放")
	if upgraded:
		for i in getCellChas(cell, 3, 2):
			buffUtil.addShengDun(i, 2)
	else:
		for i in getAroundChas(cell):
			buffUtil.addShengDun(i, 1)

func _onBattleStart():
	._onBattleStart()	
	if p4 > 1:	
		addBuff(b_roonm.new())

class b_roonm:
	extends Buff
	var dispel = 2
	func _init():
		attInit()
		id = "b_roonm"	
		att.defL = 0.5
		att.mgiDefL = 0.5