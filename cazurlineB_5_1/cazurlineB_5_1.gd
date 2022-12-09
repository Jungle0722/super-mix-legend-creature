extends "../cazurlineB_5/cazurlineB_5.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「轻巡」平海"   #角色的名称
	attCoe.maxHp += 1
	attCoe.mgiDef += 1
	lv = 3             #等级的设置
	evos = ["cazurlineB_5_1_1"]
	addSkill("战斗开始时，召唤拥有相同技能组的姐妹舰宁海并继承装备，二者都在场时，获得30%减伤", "姐妹同心")

	autoGetSkill()
	
var sisCha = null
func _onBattleStart():
	._onBattleStart()
	if lv == 3:
		sisCha = summChara("cex___altmp-B51", true)
	else:
		sisCha = summChara("cex___altmp-B511", true)
	if sisCha != null:
		sisCha.sisCha = self
		sisCha.summoner = self

func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if sisCha != null and not sisCha.isDeath:
		atkInfo.hurtVal *= 0.7