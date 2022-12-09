extends "../cazurlineC_2/cazurlineC_2.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「重巡」阿尔及利亚"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.atkRan = 2
	lv = 3             #等级的设置
	evos = ["cazurlineC_2_2_1"]
	addSkill("造成伤害时会附带3层<烧蚀>，目标身上每层烧蚀使自己对其造成的伤害提高20%", "高爆穿甲弹")

	autoGetSkill()
	setCamp("自由鸢尾")

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType != Chara.AtkType.EFF:
		atkInfo.hitCha.addBuff(utils.buffs.b_shaoShi.new(3, self))
		var buff = atkInfo.hitCha.hasBuff("b_shaoShi")
		if buff != null:
			atkInfo.factor += 0.2 * buff.life
