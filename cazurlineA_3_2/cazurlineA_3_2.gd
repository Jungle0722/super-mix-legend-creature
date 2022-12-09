extends "../cazurlineA_3/cazurlineA_3.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「驱逐」江风"   #角色的名称
	attCoe.mgiAtk += 1 #魔法攻击（每点代表13.7）
	attCoe.def += 1
	attCoe.mgiDef += 1
	lv = 3             #等级的设置
	evos = ["cex___azurlineA"]
	addSkill("施放[重型鱼雷]时有[暴击率]({damage})的几率向随机敌人额外发射2枚", "均衡鱼雷")
	autoGetSkill()
	setCamp("重樱")
		
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "zxyl" && sys.rndPer(att.cri*100):
		var chas = getAllChas(1)
		chas.shuffle()
		for i in range(2):
			if i >= chas.size() : break
			zxyl(chas[i])