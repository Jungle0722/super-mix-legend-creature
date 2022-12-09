extends Talent
func init():
	name = "舰娘打捞"

func _connect():
	sys.main.connect("onBattleStart",self,"run")

func run():
	for i in sys.main.btChas:
		if i.team == 1:
			i.addBuff(Bf.new())

func get_info():
	return "击杀敌方时，有[2%]概率捞起一名随机生物(60层后提高至3%)\n[color=#DC143C]此天赋不需要升级，所有MOD通用"

class Bf extends Buff:
	var utils = globalData.infoDs["g_azurlineUtils"]
	var dispel = 3
	func _init():
		attInit()
	func _connect():
		masCha.connect("onKillChara",self,"run")
	func run(atkInfo):
		var step = sys.main.guankaMsg.lvStep - 2
		var p = 3
		if step < 60:p = 2
		if sys.rndPer(p) && not atkInfo.hitCha.isSumm && atkInfo.hitCha.team == 2:
			var chas = getRndCha()
			for cha in chas:
				sys.main.player.addCha(cha)
				print("打捞成功:{0}".format({"0":cha.chaName}))
				var eff = sys.newEff("numHit", atkInfo.hitCha.position, false, 1)
				eff.setText("打捞成功！", "#FF0099")
				yield(sys.get_tree().create_timer(0.03), "timeout")

	#从当前池子中获得随机人物
	func getRndCha():
		var chas = []
		var rngnum = sys.rndRan(1, 1000)
		var rng = ""
		if rngnum <= 4:
			rng = sys.rndListItem(utils.lv4)
		elif rngnum <= 80:
			rng = sys.rndListItem(utils.lv3)
		elif rngnum <= 300:
			#3个lv2
			rng = sys.rndListItem(utils.lv1)
			chas.append(sys.main.newChara(rng))
			chas.append(sys.main.newChara(rng))
		else:
			rng = sys.rndListItem(utils.lv1)
		chas.append(sys.main.newChara(rng))
		return chas