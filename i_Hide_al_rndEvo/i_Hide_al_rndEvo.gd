extends "../azurline_base_item/azurline_base_item.gd"
func init():
	.init()
	name = "[稀有]基因诱变药剂"
	info = "一次性消耗品，将使用者随机进化\n65%进化为高一级的随机舰娘\n20%进化为高二级的随机舰娘\n14%进化失败，1%退化\n有概率获得限定池或科研舰娘"
func _connect():
	if masCha.lv > 3 or masCha.get("type") == "npc":return
	var rndNum = sys.rndRan(1, 100)
	if masCha.lv == 3:
		if rndNum <= 85:
			doEvo4()
		elif rndNum <= 86:
			doFail()
	else:
		if rndNum <= 65:
			doEvo(masCha.lv + 1)
		elif rndNum <= 85:
			doEvo(masCha.lv + 2)
		elif rndNum <= 86:
			doFail()
	delSelf()

func doEvo(lv):
	match lv:
		2:doEvo2()
		3:doEvo3()
		4:doEvo4()

func doEvo4():
	sys.main.player.addCha(sys.main.newChara(masCha.id))
	sys.main.player.addCha(sys.main.newChara(masCha.id))
	var chas = utils.lv4
	if sys.rndPer(3):
		chas = research.config.charaData
	var cha = sys.main.evoChara(masCha, sys.rndListItem(chas))
	cha.isDrag = true

func doEvo3():
	sys.main.player.addCha(sys.main.newChara(masCha.id))
	sys.main.player.addCha(sys.main.newChara(masCha.id))
	var chas = utils.lv3
	if sys.rndPer(15):
		chas.clear()
		for i in utils.specChas:
			chas.append(i.id)
	var cha = sys.main.evoChara(masCha, sys.rndListItem(chas))
	cha.isDrag = true

func doEvo2():
	sys.main.player.addCha(sys.main.newChara(masCha.id))
	sys.main.player.addCha(sys.main.newChara(masCha.id))
	var chas = utils.lv2
	var cha = sys.main.evoChara(masCha, sys.rndListItem(chas))
	cha.isDrag = true

#退化
func doFail():
	var cid = chaData.getLvIds(masCha.id, masCha.lv-1)
	if cid != null or cid == masCha.id:return
	sys.main.player.addCha(sys.main.newChara(masCha.id))
	sys.main.player.addCha(sys.main.newChara(masCha.id))
	var cha = sys.main.evoChara(masCha, cid)
	cha.isDrag = true