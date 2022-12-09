extends "../cazurlineF_1/cazurlineF_1.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「辅助」大青花鱼"   #角色的名称
	attCoe.mgiAtk += 1 #魔法攻击（每点代表13.7）
	lv = 3             #等级的设置
	evos = ["cazurlineF_1_2_1"]
	addSkill("技能造成伤害时，追加10层<漏水>效果", "意外赠礼")

	autoGetSkill()
	setCamp("白鹰")

func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.SKILL:
		buffUtil.addLouShui(atkInfo.hitCha, self, 10)