extends "../cazurlineC_3/cazurlineC_3.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「重巡」罗恩"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	attCoe.mgiDef += 1  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cex___als-roon2"]
	canCopy = false
	addSkill("受到伤害时，50%概率获得1层<圣盾>", "全方位防御")
	ename = "luoen"

	autoGetSkill()
	supportSpecEvo = 2
	setCamp("铁血")
	itemEvoCha2 = "cex___almiu-roonm"

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if sys.rndPer(50):
		buffUtil.addShengDun(self, 1)