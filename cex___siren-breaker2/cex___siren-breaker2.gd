extends "../cex___siren-breaker1/cex___siren-breaker1.gd"
func _info():
	pass
func _connect():
	._connect()

func _extInit():
	._extInit()
	chaName = "「塞壬」破局者II型"   #角色的名称
	lv = 3             #等级的设置
	attCoe.maxHp += 1
	attCoe.def += 1
	attCoe.mgiDef += 1
	attCoe.atk += 2
	addSkillTxt("[破局]-全体友军死亡时将会满血复活")
	evos = ["cex___siren-breaker3"]
	
func _onBattleStart():
	._onBattleStart()
	var chas = getAllChas(2)
	for i in chas:
		if not i.hasBuff("b_jinJiQiangXiu") && i.get("type") != "BOSS":
			i.addBuff(b_jinJiQiangXiu.new())

class b_jinJiQiangXiu:
	extends Buff
	func _init():
		attInit()
		id = "b_jinJiQiangXiu"	

	func _connect():
		masCha.connect("onDeath",self,"_onDeath")

	func _onDeath(atkInfo):
		masCha.isDeath = false
		masCha.plusHp(masCha.att.maxHp)
		masCha.delBuff(masCha.hasBuff("b_jinJiQiangXiu"))




