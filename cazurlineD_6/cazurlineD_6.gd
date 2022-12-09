extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」敦刻尔克"   #角色的名称
	attCoe.atkRan = 3  #攻击距离
	attCoe.maxHp += 1   #最大生命（呈现在游戏中时，每点代表112.5，取整数，下同）
	attCoe.atk += 1     #攻击力（每点代表8.5）
	attCoe.def += 1     #物理防御（每点代表15）
	lv = 2             #等级的设置
	evos = ["cazurlineD_6_1", "cazurlineD_6_2"]
	addSkill("每{cd}秒赋予[最靠前]的4名友军2层<圣盾>", "维持战线", "holdLine", 6)

	setCamp("自由鸢尾")

func _castCdSkill(id):
	._castCdSkill(id)
	if id=="holdLine":
		holdLine()

func holdLine():
	var chas = getAllChas(2)
	chas.sort_custom(self,"sortByFront")
	for i in range(4):
		if i >= chas.size():break
		buffUtil.addShengDun(chas[i], 2)


