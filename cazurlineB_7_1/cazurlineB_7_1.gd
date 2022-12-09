extends "../cazurlineB_7/cazurlineB_7.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「轻巡」基洛夫"   #角色的名称
	attCoe.maxHp += 1
	attCoe.mgiDef += 1
	lv = 3             #等级的设置
	evos = ["cazurlineB_7_1_1"]
	addSkill("每{cd}秒赋予所有拥有<霜冻>效果的敌人，同等层数的<漏水>", "破裂冰结", "polieBJ", 9)
	ename = "jiluofu"
	autoGetSkill()
	
func _castCdSkill(id):
	._castCdSkill(id)
	if id=="polieBJ":
		polieBJ()

func polieBJ():
	for i in getAllChas(1):
		var bf = i.hasBuff("b_freeze")
		if bf != null:
			buffUtil.addLouShui(i, self, bf.life)