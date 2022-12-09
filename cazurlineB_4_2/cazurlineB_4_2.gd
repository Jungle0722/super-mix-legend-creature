extends "../cazurlineB_4/cazurlineB_4.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「轻巡」圣女贞德"   #角色的名称
	attCoe.maxHp += 1
	attCoe.mgiDef += 1
	attCoe.atkRan = 5
	lv = 3             #等级的设置
	evos = ["cazurlineB_4_2_1"]
	addSkill("<限定>周围(九宫格范围)存在血量低于40%的友军时触发，恢复该角色生命值，\n			并使我方所有角色承疗提高100%，敌方所有角色伤害降低50%，持续5秒", "休战时间")
	autoGetSkill()
	setCamp("自由鸢尾")
var skFlag = true
func _upS():
	._upS()
	if not skFlag:return
	for i in getAroundChas(cell):
		if i.att.hp/i.att.maxHp < 0.4:
			utils.createSkillTextEff("休战时间", position)
			skFlag = false
			healCha(i, i.att.maxHp)
			for j in getAllChas(2):
				j.addBuff(buffUtil.b_reHp.new(10,5))
			for j in getAllChas(1):
				j.addBuff(buffUtil.b_atkR.new(-5,5))

func _onBattleEnd():
	._onBattleEnd()
	skFlag = true