extends "../cazurlineA_3_1/cazurlineA_3_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」雪风·改"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 2
	lv = 4             #等级的设置
	addSkill("每秒赋予周围2格敌人2层<霜冻>，受到技能伤害时，自己与绑定队友各恢复15%血量", "冬之精灵")
	addSkillTxt("[color=#C0C0C0][现代化改造]-冬之精灵作用范围+1(未解锁)")
	type2 = "doctor"
	if upgraded:
		skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	addSkillTxt("[color=#C0C0C0]当雪风认为自己不再能够保护大家(绑定队友死亡)，可能发生意想不到的变化...")
	if isAwaken:
		awaken()

func awaken(msg = true):
	chaName = "「驱逐」雪风·觉醒"
	addSkill("受到技能伤害也能触发不沉的幸运舰效果，且分摊给敌人的伤害提高200%", "心智觉醒", null, null, skillStrs.size() - 1)
	if not isAwaken and team == 1:
		sys.newBaseMsg("事件", "雪风已经获得了心智觉醒！")
		isAwaken = true

var baseId = ""
var s4Flag = true
func _upS():
	._upS()
	s4Flag = true
	for i in getCellChas(cell, p4, 1):
		i.addBuff(utils.buffs.b_freeze.new(2))

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if atkInfo.atkType == Chara.AtkType.SKILL and s4Flag:
		s4Flag = false
		healCha(self, att.maxHp*0.15)
		if ally != null and not ally.isDeath:
			healCha(ally, ally.att.maxHp*0.15)
	if isAwaken and atkInfo.atkType == Chara.AtkType.SKILL and not atkInfo.atkCha.isDeath:
		azurHurtChara(atkInfo.atkCha, atkInfo.atkVal, atkInfo.hurtType, Chara.AtkType.EFF, "心智觉醒")

var p4 = 2
func upgrade():
	skillStrs[skillStrs.size()-1] = skillStrs[skillStrs.size()-1].replace("未解锁", "已解锁")
	skillStrs[skillStrs.size()-2] = skillStrs[skillStrs.size()-2].replace("未解锁", "已解锁")
	p4 = 3