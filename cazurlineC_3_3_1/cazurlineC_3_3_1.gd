extends "../cazurlineC_3_3/cazurlineC_3_3.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」塔林·改"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	lv = 4             #等级的设置
	addSkill("受到致命伤害时，若存在未死亡的分身，则牺牲该分身，使自己恢复50%血量", "冰血之忆")

	addSkillTxt("[color=#C0C0C0][现代化改造]-分身获得核弹运输技能，冰血之忆触发时，恢复全部血量(未解锁)")
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
var baseId = ""
var enable2 = true
var p4 = 0.5
func _onDeath(atkInfo):
	._onDeath(atkInfo)
	if not enable2 or summedCha.empty() or not isDeath:return
	enable2 = false
	for i in summedCha:
		if i.isDeath:continue
		isDeath = false
		healCha(self, att.maxHp*p4)
		forceKillCha(i)
		summedCha.erase(i)

func upgrade():
	p4 = 1
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")

func _onBattleEnd():
	._onBattleEnd()
	enable2 = true