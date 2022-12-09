extends "../cazurlineB_2/cazurlineB_2.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「轻巡」纽伦堡"   #角色的名称
	lv = 3             #等级的设置
	attAdd.atkL -= 0.15
	attCoe.mgiDef += 1
	evos = ["cazurlineB_2_3_1"]
	addSkill("攻击降低15%，普攻额外攻击两个目标", "火力覆盖")
	autoGetSkill()
	setCamp("铁血")
var p3 = 3
func normalAtkChara(cha):
	if not is_instance_valid(cha):return
	var chas = getCellChas(cell, att.atkRan, 1)
	chas.sort_custom(self, "sortByDistance")
	for i in range(p3):
		if i >= chas.size():break
		.normalAtkChara(chas[i])
				

	
		