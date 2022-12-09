extends "../cex___als-javelin/cex___als-javelin.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」标枪·改"   #角色的名称
	attCoe.mgiAtk += 4   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiDef += 4
	lv = 4             #等级的设置
	addSkill("对目标造成普攻伤害后，若目标魔抗低于自身，则立即使皇家标枪冷却完毕", "毁灭之力")

	addSkillTxt("[color=#C0C0C0][现代化改造]-皇家标枪还将附带6层<烧蚀><漏水><流血>，对塞壬造成的魔抗削减提高200%(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL and atkInfo.hitCha.att.mgiDef < att.mgiDef:
		var sk = getSkill("sk_javelin1")
		sk.nowTime += sk.cd
