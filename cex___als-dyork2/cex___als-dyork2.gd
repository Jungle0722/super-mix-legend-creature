extends "../cex___als-dyork/cex___als-dyork.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」约克公爵·改"   #角色的名称
	attCoe.maxHp +=2
	attCoe.mgiDef += 1
	lv = 4             #等级的设置
	addSkill("战斗开始20秒时复活所有阵亡的[非召唤]友军", "回魂夜")

	addSkillTxt("[color=#C0C0C0][现代化改造]-回收效率提高50%，复活的友军获得1秒<无敌>(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
func upgrade():
	p3 = 15
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""

var skFlag = 0
var skFlag2 = true
func _upS():
	._upS()
	skFlag += 1
	if skFlag >= 20 and skFlag2:
		skFlag2 = false
		for i in deathChas:
			i.isDeath = false
			i.plusHp(i.att.maxHp)
			i.revive(i.att.maxHp)
			if sys.main.matCha(i.cell) != null:
				for tcell in utils.getAllCells(1):
					if sys.main.matCha(tcell) != null:
						i.setCell(tcell)
						break
			if upgraded:
				i.addBuff(buffUtil.b_wudi.new(1))

func _onBattleEnd():
	._onBattleEnd()
	skFlag = 0
	skFlag2 = true