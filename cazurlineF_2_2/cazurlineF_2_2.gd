extends "../cazurlineF_2/cazurlineF_2.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「辅助」明石·维修型"   #角色的名称
	lv = 3             #等级的设置
	evos = ["cex___azurlineF"]
	addSkill("每{cd}秒随机恢复3名非满血友军[双攻*3]({damage})的生命值", "后勤维修", "hqwx", 5)

	autoGetSkill()
	setCamp("重樱")
	itemEvoCha = "cex___al-mingShi"
	ename = "mingshi"
func _castCdSkill(id):
	._castCdSkill(id)
	if id == "hqwx":
		hqwx()

func hqwx():
	var chas = getAllChas(2)
	chas.shuffle()
	var dmg = (att.mgiAtk + att.atk) * 3
	if upgraded:
		for i in chas:
			healCha(i, dmg*0.5)
	else:
		for i in range(3):
			if i >= chas.size() : break
			if chas[i].att.hp < chas[i].att.maxHp:
				healCha(chas[i], dmg)