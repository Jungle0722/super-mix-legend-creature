extends "../cex___warship/cex___warship.gd"
var getPlaneCount = 0
var getPlaneRnd = 10

func castPlane():
	pass

func _onBattleStart():
	._onBattleStart()
	# self.castPlane()
	var sk = getSkill("castPlane")
	sk.nowTime = sk.cd - 1.5
	
	if team == 1 && getPlaneRnd > 0 && sys.rndPer(getPlaneRnd):
		getPlaneCount += 1
		getPlaneRnd -= 5
		var item = sys.newItem("i_Hide_plane")
		item.repair(false)
		sys.main.player.addItem(item)

func _extInit():
	._extInit()
	type = "cv"
	prefer = "sup"
