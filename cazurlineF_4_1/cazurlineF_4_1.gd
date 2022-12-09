extends "../cazurlineF_4/cazurlineF_4.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「辅助」22"   #角色的名称
	attCoe.mgiAtk += 1 #魔法攻击（每点代表13.7）
	attCoe.maxHp += 1
	lv = 3             #等级的设置
	evos = ["cazurlineF_4_1_1"]
	addSkill("每{cd}秒赋予周围（九宫格范围）的友军[200+法强*1.2]({damage})的护盾值", "护盾充能", "shieldCharge", 7)

	autoGetSkill()
	setCamp("其他")

func _castCdSkill(id):
	._castCdSkill(id)
	if id == "shieldCharge":
		shieldCharge()

func shieldCharge():
	for i in getAroundChas(cell):
		if not i.has_method("changeShield"):continue
		i.changeShield(200 + att.mgiAtk*1.2)