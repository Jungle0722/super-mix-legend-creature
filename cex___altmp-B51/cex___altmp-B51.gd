extends "../cazurlineB_5/cazurlineB_5.gd"
func _info():
	pass
func _connect():
	._connect()
var summoner
func _extInit():
	._extInit()
	chaName = "「轻巡」宁海"   #角色的名称
	attCoe.maxHp += 1
	attCoe.atk += 1
	isSumm = true
	lv = 3             #等级的设置
	addSkillTxt("[color=#BDB76B][姐妹同心]-平海在场时，获得40%减伤[/color]")

var sisCha
func _onHurt(atkInfo):
	._onHurt(atkInfo)
	if sisCha != null and not sisCha.isDeath:
		atkInfo.hurtVal *= 0.6