extends "../cazurlineB_2/cazurlineB_2.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「轻巡」神通"   #角色的名称
	lv = 3             #等级的设置
	attCoe.atk += 1     #攻击力（每点代表8.5）
	evos = ["cazurlineB_2_1_1"]
	addSkill("普攻时额外对另一名射程内的敌人进行普攻", "齐射")
	autoGetSkill()
	setCamp("重樱")

func normalAtkChara(cha):
	if not is_instance_valid(cha):return
	var chas = getCellChas(cell, att.atkRan, 1)
	chas.sort_custom(self,"sortByDistance")
	for i in chas:
		if i != cha:
			.normalAtkChara(i)
			break
	.normalAtkChara(cha)
				

	
		