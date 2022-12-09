extends "../cazurlineE/cazurlineE.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「航母」独角兽"   #角色的名称
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.mgiAtk += 1     #攻击力（每点代表8.5）
	lv = 2             #等级的设置
	evos = ["cazurlineE_1_1","cazurlineE_1_2"]
	addSkill("每{cd}秒恢复生命值最低的友军[法强*2]({damage})的生命值(可暴击)", "支援空母", "supportDJS", 5)
	type2 = "doctor"
	setCamp("皇家")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="supportDJS":
		cast1()
	
func cast1():
	var chas = getAllChas(2)
	chas.sort_custom(self,"sortByHp")
	var dmg = att.mgiAtk * 2
	if sys.rndPer(att.cri * 100):dmg *= 2+att.criR
	healCha(chas[0], dmg)

