extends "../cazurlineB_5/cazurlineB_5.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「轻巡」肇和"   #角色的名称
	attCoe.maxHp += 1
	attCoe.def += 1
	lv = 3             #等级的设置
	evos = ["cazurlineB_5_2_1"]
	addSkill("<亡语>复制2名继承自身装备的随机非塞壬敌方角色", "镜花水月")
	autoGetSkill()
	
func deathWord():
	.deathWord()
	var chas = getAllChas(1)
	chas.shuffle()
	var p = 2
	if not isDeath:p = 1
	for i in range(p):
		if i >= chas.size():break
		if chas[i].get("type") == "BOSS":continue
		if team == 1:
			summChara(chas[i].id, true)
		else:
			summChara(chas[i].id, false)
			break
		