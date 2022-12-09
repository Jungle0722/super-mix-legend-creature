extends "../cazurlineC_3/cazurlineC_3.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「重巡」欧根亲王"   #角色的名称
	attCoe.maxHp += 2   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.def += 2     #物理防御（每点代表15）
	attCoe.mgiDef += 2  #魔法防御（每点代表16.6）
	lv = 3             #等级的设置
	evos = ["cazurlineC_3_1_1"]
	addSkill("开局获得相当于自身血上限的<护盾>，护盾每秒恢复[血上限*0.05]({damage})点", "不破之盾")

	autoGetSkill()
	setCamp("铁血")
var p3 = 0.05
func _onBattleStart():
	._onBattleStart()
	changeShield(-shield)
	changeShield(att.maxHp)
	
func _upS():
	._upS()
	changeShield((min(att.maxHp, 3000))*p3)