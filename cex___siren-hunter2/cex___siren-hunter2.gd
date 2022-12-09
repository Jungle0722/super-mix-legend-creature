extends "../cex___siren-hunter1/cex___siren-hunter1.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「塞壬」追迹者II型"   #角色的名称
	lv = 3             #等级的设置
	addSkillTxt("[寻迹]-击杀敌人时，伤害提升30%")
	evos = ["cex___siren-hunter3"]

var p1 = 1
func _onAtkChara(atkInfo):
	._onAtkChara(atkInfo)
	if atkInfo.atkType == Chara.AtkType.NORMAL && atkInfo.hurtVal > 0:
		atkInfo.hurtVal *= p1

func _onKillChara(atkInfo:AtkInfo):
	._onKillChara(atkInfo)
	if not atkInfo.hitCha.isSumm:
		p1 += 0.3

func _onBattleEnd():
	._onBattleEnd()
	p1 = 1