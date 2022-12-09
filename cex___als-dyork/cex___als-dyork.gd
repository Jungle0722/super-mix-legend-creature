extends "../cazurlineD/cazurlineD.gd"
func _info():
	pass
func _connect():
	._connect()
	
func _extInit():
	._extInit()
	chaName = "「战列」约克公爵"   #角色的名称
	attCoe.mgiDef += 2
	attCoe.maxHp += 2
	lv = 3             #等级的设置
	evos = ["cex___als-dyork2"]
	canCopy = false
	addSkill("[非召唤]友军彻底阵亡时，获得10金币", "回收")
	addSkill("[非召唤]友军彻底阵亡时，1%几率[获得]该单位", "打捞")
	ename = "yuekegongjue"
	autoGetSkill()
	supportSpecEvo = 2
	setCamp("皇家")
var deathChas = []
var p3 = 10
func _onCharaDel(cha):
	._onCharaDel(cha)
	if not is_instance_valid(cha) or isDeath:return
	if cha.team == team and not cha.isSumm:
		deathChas.append(cha)
		sys.main.player.plusGold(p3)
		if sys.rndPer(1) and cha.get("canCopy") != false and cha.get("isResearch") != true and cha.get("type") != "siren":
			sys.main.player.addCha(sys.main.newChara(cha.id))

func _onBattleEnd():
	._onBattleEnd()
	deathChas.clear()